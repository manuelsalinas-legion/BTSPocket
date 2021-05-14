//
//  TeamViewController.swift
//  BTSPocket
//
//  Created by bts on 25/03/21.
//

import UIKit

class TeamViewController: UIViewController {
    
    // MARK:- Outlets and Variables
    @IBOutlet weak private var tableViewTeam: UITableView!
//    @IBOutlet weak var searchBar: UISearchBar!
    
    private var currentPage: Int = 0
    private var totalPages: Int?
    private var teamsVM: TeamViewModel = TeamViewModel()
    private var allUsers: [User]? {
        didSet { self.tableViewTeam.reloadData() }
    }
    private var searchbarController = UISearchController()
    private var refreshControl = UIRefreshControl()
    
    // MARK:- life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTable()
        self.setUpUsers()
        self.setUpSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Team"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK:- setUpSearch bar function
    private func setUpSearchBar() {
        self.searchbarController.searchBar.placeholder = "Search Team Member"
        self.searchbarController.obscuresBackgroundDuringPresentation = false
        self.searchbarController.searchBar.sizeToFit()
        self.searchbarController.searchBar.delegate = self
        self.navigationItem.searchController = searchbarController
        
        // refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.reload), for: .valueChanged)
        self.tableViewTeam.addSubview(refreshControl)
    }
    
    // MARK:- setUpTable function
    private func setUpTable() {
        self.tableViewTeam.registerNib(UserTableViewCell.self)
    }
    
    // MARK:- setUpUsers function
    private func setUpUsers() {
        self.currentPage = 1
        self.teamsVM.getTeamMembers(self.currentPage, searchbarController.searchBar.text, { [weak self] result in
            switch result {
            case .success(let paginationUsers):
                self?.allUsers = paginationUsers.items
                self?.totalPages = paginationUsers.pages ?? 1
                self?.currentPage = paginationUsers.currentPage ?? 0
            case .failure(let error):
                if error.asAFError?.responseCode == HttpStatusCode.forbidden.rawValue {
                    BTSApi.shared.deleteSession()
                    self?.showLogin()
                } else {
                    self?.showGenericErrorAlert("Error", "Generic Error", "OK")
                }
            }
        })
    }
}
// MARK:- UITable delegate and DataSource
extension TeamViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: UserTableViewCell.self)
        let user = self.allUsers?[indexPath.row]
        cell.setUserInfo(user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    // Add next page into all users list
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = (self.allUsers?.count ?? 1) - 2
        let nextPage = self.currentPage + 1
        
        if indexPath.row == lastElement,
           nextPage <= self.totalPages ?? 0 {
            // call pagination users
            self.teamsVM.getTeamMembers(nextPage, searchbarController.searchBar.text, { [weak self] result in
                switch result {
                    case .success(let usersPage):
                        self?.allUsers? += usersPage.items ?? []
                        self?.tableViewTeam.reloadData()
                        self?.currentPage = nextPage
                    case .failure(let error):
                        if error.asAFError?.responseCode == HttpStatusCode.forbidden.rawValue {
                            BTSApi.shared.deleteSession()
                            self?.showLogin()
                        } else if error.asAFError?.responseCode == HttpStatusCode.timeout.rawValue {
                            MessageManager.shared.showBar(title: "Connectig failed", subtitle: "Can't load more members", type: .warning, containsIcon: false, fromBottom: true)
                        } else {
                            self?.showGenericErrorAlert("Error", "Generic Error", "OK")
                        }
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vcProfile = Storyboard.getInstanceOf(ProfileViewController.self)
        vcProfile.mode = .teamMember
        vcProfile.memberId = self.allUsers?[indexPath.row].id

        self.navigationController?.pushViewController(vcProfile, animated: true)
    }
}

// MARK:- SEARCH BAR (UISearchBarDelegate)
extension TeamViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // if search bar isn't empty
        if searchBar.text?.trim().isEmpty == false {
            // canceling request typing before 1 second
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: searchBar)
            perform(#selector(self.reload), with: searchBar, afterDelay: 1.0)
        } else {
            // reload pages
            self.allUsers = []
            self.setUpUsers()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // reload pages
        #warning("Cristian reset table here")
    }
    
    @objc func reload() {
        self.teamsVM.getTeamMembers(1, searchbarController.searchBar.text, { [weak self] result in
            switch result {
                case .success(let usersPage):
                    self?.allUsers? = usersPage.items ?? []
                    self?.tableViewTeam.reloadData()
                case .failure(let error):
                    if error.asAFError?.responseCode == HttpStatusCode.forbidden.rawValue {
                        BTSApi.shared.deleteSession()
                        self?.showLogin()
                    } else if error.asAFError?.responseCode == HttpStatusCode.timeout.rawValue {
                        MessageManager.shared.showBar(title: "Connectig failed", subtitle: "Can't load more members", type: .warning, containsIcon: false, fromBottom: true)
                    } else {
                        self?.showGenericErrorAlert("Error", "Generic Error", "OK")
                    }
            }
        })
        self.refreshControl.endRefreshing()
    }
}
