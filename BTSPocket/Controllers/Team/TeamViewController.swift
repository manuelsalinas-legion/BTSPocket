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
    
    public var page: Int = 0
    private var pages: Int = 1
    private var teamsVM: TeamViewModel?
    private var allUsers: [User]? {
        didSet { self.tableViewTeam.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.teamsVM = TeamViewModel()
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
        self.teamsVM?.getTeamMembers(self.page, { result in
            switch result {
            case .success(let paginationUsers):
                self.allUsers = paginationUsers.items
                self.pages = paginationUsers.pages ?? 1
            case .failure(let error):
                if error.asAFError?.responseCode == HttpStatusCode.forbidden.rawValue {
                    BTSApi.shared.deleteSession()
                    self.showLogin()
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
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = (self.allUsers?.count ?? 1) - 2
        if indexPath.row == lastElement,
           self.page <= self.pages {
            // call pagination users
            self.teamsVM?.getTeamMembers(self.page, { result in
                switch result {
                    case .success(let usersPage):
                        self.allUsers? += usersPage.items ?? []
                        self.tableViewTeam.reloadData()
                        self.page = self.page + 1
                    case .failure(let error):
                        if error.asAFError?.responseCode == HttpStatusCode.forbidden.rawValue {
                            BTSApi.shared.deleteSession()
                            self.showLogin()
                        }
                        if error.asAFError?.responseCode == HttpStatusCode.timeout.rawValue {
                            MessageManager.shared.showBar(title: "Connectig failed", subtitle: "Can't load more members", type: .warning, containsIcon: false, fromBottom: true)
                        }
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcProfile = Storyboard.getInstanceOf(ProfileViewController.self)
        vcProfile.mode = .teamMember
        vcProfile.memberId = self.allUsers?[indexPath.row].id
        self.navigationController?.pushViewController(vcProfile, animated: true)
    }
}
