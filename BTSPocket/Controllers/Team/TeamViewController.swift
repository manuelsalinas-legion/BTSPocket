//
//  TeamViewController.swift
//  BTSPocket
//
//  Created by bts on 25/03/21.
//

import UIKit

enum ReloadType {
    case firstPage
    case refresh(Int, String)
    case nextPage(Int, String)
}

enum TeamListStyle {
    case allUsers, projectUsers
}

class TeamViewController: UIViewController {
    
    // MARK:- Outlets and Variables
    @IBOutlet weak private var tableViewTeam: UITableView!
    
    private var searchbarController = UISearchController()
    private var refreshControl = UIRefreshControl()
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private var teamsVM: TeamViewModel = TeamViewModel()
    private var projectVM: ProjectsViewModel = ProjectsViewModel()
    private var allUsers: [User]? {
        didSet {
            DispatchQueue.main.async { self.tableViewTeam.reloadData() }
        }
    }
    private var projectUsers: [UserInProject]? {
        didSet {
            DispatchQueue.main.async { self.tableViewTeam.reloadData() }
        }
    }
    var mode: TeamListStyle = .allUsers
    var project: Project?
    
    // MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        switch mode {
        case .allUsers:
            // Title
            self.title = "Team".localized
            // Load all users info
            self.getTeamMembers(.firstPage)
        case .projectUsers:
            // Title
            self.title = (project?.name ?? "") + "Team".localized
            // Load users in project infor
            self.getProfileTeamMembers()
        }
    }
        
    // MARK: SETUP
    private func setupUI() {
        // Search controller
        self.searchbarController.searchBar.backgroundColor = .btsBlue()
        self.searchbarController.searchBar.tintColor = .white
        self.searchbarController.searchBar.barStyle = .black
        self.searchbarController.searchBar.searchTextField.tintColor = .white
        self.searchbarController.searchBar.placeholder = "Search Team Member"
        self.searchbarController.obscuresBackgroundDuringPresentation = false
        self.searchbarController.searchBar.sizeToFit()
        self.searchbarController.searchBar.delegate = self
        
        switch mode {
        case .allUsers:
            self.navigationItem.searchController = self.searchbarController
        case .projectUsers:
            self.navigationItem.searchController = nil
        }
        
        // Table
        self.tableViewTeam.registerNib(UserTableViewCell.self)
        self.tableViewTeam.hideEmtpyCells()
        
        // refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.reload), for: .valueChanged)
        self.tableViewTeam.addSubview(self.refreshControl)
    }
    
    // MARK:- WEB SERVICE TO GET USER PROJECTS
    private func getProfileTeamMembers() {
        self.projectVM.getProjectDetails(project?.id) { [weak self] (result) in
            switch result {
            case .success(let projectDetails):
                self?.projectUsers = projectDetails.activeUsers
                self?.tableViewTeam.reloadData()
            case .failure(let error):
                if error.asAFError?.responseCode == HttpStatusCode.forbidden.rawValue {
                    // Logout
                    self?.logout()
                } else {
                    self?.tableViewTeam.displayBackgroundMessage(message: "No project members found".localized)
                    MessageManager.shared.showBar(title: "Info", subtitle: "Cannot get members", type: .info, containsIcon: true, fromBottom: false)
                }
            }
        }
    }
    
    // MARK:- WEB SERVICE
    private func getTeamMembers(_ reloadType: ReloadType) {
        let typeOfRequest: RequestType
        switch reloadType {
        case .firstPage:
            typeOfRequest = .justPage(1)
        case .nextPage(let page, let text):
            typeOfRequest = .pageAndFilter(page, text)
        case .refresh(let page, let text):
            typeOfRequest = .pageAndFilter(page, text)
        }
        
        self.teamsVM.getTeamMembers(typeOfRequest) { [weak self] result in
            switch result {
            case .success(let paginationUser):
                
                switch reloadType {
                case .firstPage:
                    self?.allUsers = paginationUser.items
                case .nextPage(_, _):
                    self?.allUsers? += paginationUser.items ?? []
                case .refresh(_, _):
                    self?.allUsers = paginationUser.items
                }
                // Empty state
                if self?.allUsers?.isEmpty == true {
                    self?.tableViewTeam.displayBackgroundMessage(message: "No team members found".localized)
                } else {
                    self?.tableViewTeam.dismissBackgroundMessage()
                }
                
                self?.totalPages = paginationUser.pages ?? 1
                self?.currentPage = paginationUser.currentPage ?? 1
                self?.tableViewTeam.reloadData()
                
            case .failure(let error):
                if error.asAFError?.responseCode == HttpStatusCode.forbidden.rawValue {
                    // Logout
                    self?.logout()
                } else {
                    self?.tableViewTeam.displayBackgroundMessage(message: "No team members found".localized)
                    MessageManager.shared.showBar(title: "Info", subtitle: "Cannot get members", type: .info, containsIcon: true, fromBottom: false)
                }
            }
        }
    }
}
// MARK:- UITable delegate and DataSource
extension TeamViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mode {
        case .allUsers:
            return self.allUsers?.count ?? 0
        case .projectUsers:
            return self.projectUsers?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: UserTableViewCell.self)
        // hacer ternacio a base de mode y eviar a la celda el tipo de usuario que necesita
        switch mode {
        case .allUsers:
            let user = self.allUsers?[indexPath.row]
            cell.setUserInfo(.user(user))
        case .projectUsers:
            let user = self.projectUsers?[indexPath.row]
            cell.setUserInfo(.projectUser(user))
        }
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
           nextPage <= self.totalPages {
            self.getTeamMembers(.nextPage(nextPage, self.searchbarController.searchBar.text?.trim() ?? ""))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vcProfile = Storyboard.getInstanceOf(ProfileViewController.self)
        vcProfile.mode = .teamMember
        switch mode {
        case .allUsers:
            vcProfile.memberId = self.allUsers?[indexPath.row].id
        case .projectUsers:
            vcProfile.memberId = self.projectUsers?[indexPath.row].id
        }

        self.navigationController?.pushViewController(vcProfile, animated: true)
    }
}

// MARK:- SEARCH BAR (UISearchBarDelegate)
extension TeamViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // if search bar isn't empty
        if let text = searchBar.text?.trim() {
            if !text.isEmpty {
                if text.count >= 3 {
                    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: searchBar)
                    perform(#selector(self.reload), with: searchBar, afterDelay: 1.0)
                }
            } else {
                self.getTeamMembers(.firstPage)
            }
        }
    }
    
    // search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text?.trim() {
            if !text.isEmpty {
                if text.count < 3 {
                    MessageManager.shared.showBar(title: "Warning", subtitle: "You have to write at least three characters", type: .warning, containsIcon: true, fromBottom: false)
                }
            }
        }
    }
    
    // cancel button clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        switch mode {
        case .allUsers:
            self.getTeamMembers(.firstPage)
        case .projectUsers:
            self.getProfileTeamMembers()
        }
    }
    
    // reload page of users
    @objc func reload() {
        self.getTeamMembers(.refresh(1, self.searchbarController.searchBar.text?.trim() ?? ""))
        self.refreshControl.endRefreshing()
    }
}
