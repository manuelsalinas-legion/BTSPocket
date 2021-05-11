//
//  TeamViewController.swift
//  BTSPocket
//
//  Created by bts on 25/03/21.
//

import UIKit

class TeamViewController: UIViewController {
    
    // MARK:- Outlets and Variables
    @IBOutlet weak var tableViewTeam: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var page: Int = 0
    private var pages: Int?
    private var teamsVM: TeamViewModel = TeamViewModel()
    private var allUsers: [User]? {
        didSet { self.tableViewTeam.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTable()
        self.setUpUsers()
    }
    
    // MARK:- setUpTable
    func setUpTable() {
        self.page = 1
        tableViewTeam.registerNib(UserTableViewCell.self)
    }
    
    // MARK:- setUpUsers function
    func setUpUsers() {
        self.teamsVM.getTeamMembers(self.page, searchBar.text, { result in
            switch result {
            case .success(let paginationUsers):
                self.allUsers = paginationUsers.items
                self.pages = paginationUsers.pages ?? 1
                self.page = paginationUsers.currentPage ?? 0
            case .failure(let error):
                if error.asAFError?.responseCode == HttpStatusCode.forbidden.rawValue {
                    BTSApi.shared.deleteSession()
                    self.showLogin()
                } else {
                    self.showGenericErrorAlert("Error", "Generic Error", "OK")
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
        let nextPage = self.page + 1
        // Obviamente no se que esta pasando aqui pero tiene que entrar aqui despues de la paginacion y tiene que mostrar
        // la siguiente pagina de alguna manera, o solamente que este algo mal...
        if indexPath.row == lastElement,
           nextPage <= self.pages ?? 0 {
            // call pagination users
            self.teamsVM.getTeamMembers(nextPage, searchBar.text, { result in
                switch result {
                    case .success(let usersPage):
                        self.allUsers? += usersPage.items ?? []
                        self.tableViewTeam.reloadData()
                        self.page = nextPage
                    case .failure(let error):
                        if error.asAFError?.responseCode == HttpStatusCode.forbidden.rawValue {
                            BTSApi.shared.deleteSession()
                            self.showLogin()
                        } else if error.asAFError?.responseCode == HttpStatusCode.timeout.rawValue {
                            MessageManager.shared.showBar(title: "Connectig failed", subtitle: "Can't load more members", type: .warning, containsIcon: false, fromBottom: true)
                        } else {
                            self.showGenericErrorAlert("Error", "Generic Error", "OK")
                        }
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcProfile = Storyboard.getInstanceOf(ProfileViewController.self)
        vcProfile.mode = .teamMember
        vcProfile.memberId = self.allUsers?[indexPath.row].id
        vcProfile.modalPresentationStyle = .fullScreen
        self.present(vcProfile, animated: true, completion: nil)
    }
}

// MARK:- Search bar config
extension TeamViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.trim() != "" {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
            perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 1.0)
        } else {
            self.page = 1
            self.allUsers = []
            self.setUpUsers()
        }
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        self.teamsVM.getTeamMembers(1, searchBar.text, { result in
            switch result {
                case .success(let usersPage):
                    self.allUsers? = usersPage.items ?? []
                    self.tableViewTeam.reloadData()
                case .failure(let error):
                    if error.asAFError?.responseCode == HttpStatusCode.forbidden.rawValue {
                        BTSApi.shared.deleteSession()
                        self.showLogin()
                    } else if error.asAFError?.responseCode == HttpStatusCode.timeout.rawValue {
                        MessageManager.shared.showBar(title: "Connectig failed", subtitle: "Can't load more members", type: .warning, containsIcon: false, fromBottom: true)
                    } else {
                        self.showGenericErrorAlert("Error", "Generic Error", "OK")
                    }
            }
        })
    }
}
