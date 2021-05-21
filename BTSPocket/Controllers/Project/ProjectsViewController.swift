//
//  ProjectViewController.swift
//  BTSPocket
//
//  Created by bts on 25/03/21.
//

import UIKit

class ProjectsViewController: UIViewController {
    
    // MARK:- Outlets and Variables
    @IBOutlet weak var tableViewProjects: UITableView!
    
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private var searchController = UISearchController()
    private var refreshControl = UIRefreshControl()
    private var projectsVM = ProjectsViewModel()
    private var projectsByUser: [Project]? {
        didSet {
            DispatchQueue.main.async { self.tableViewProjects.reloadData() }
        }
    }
    
    // MARK: Life cicles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    // MARK: setupUI function
    private func setUpUI() {
        self.title = "Projects".localized
        
        // Search controller
        self.searchController.searchBar.backgroundColor = .btsBlue()
        self.searchController.searchBar.tintColor = .white
        self.searchController.searchBar.barStyle = .black
        self.searchController.searchBar.searchTextField.tintColor = .white
        self.searchController.searchBar.placeholder = "Search Projects"
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.delegate = self
        
        self.navigationItem.searchController = self.searchController
        
        // Table
        self.tableViewProjects.hideEmtpyCells()
        self.tableViewProjects.registerNib(ProjectTableViewCell.self)
        
        // Refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.reload), for: .valueChanged)
        self.tableViewProjects.addSubview(refreshControl)
        
        self.getProjectsByUser(.firstPage)
    }
    
    // MARK: WEB SERVICE
    private func getProjectsByUser(_ reloadType: ReloadType) {
        let typeOfRequest: RequestType
        switch reloadType {
        case .firstPage:
            typeOfRequest = .justPage(1)
        case .nextPage(let page, let text):
            typeOfRequest = .pageAndFilter(page, text)
        case .refresh(let page, let text):
            typeOfRequest = .pageAndFilter(page, text)
        }
        self.projectsVM.getProjectsByUser(typeOfRequest) { [weak self] response in
            switch response {
            case .success(let paginationProjects):
                switch reloadType {
                case .firstPage:
                    self?.projectsByUser = paginationProjects.items
                case .nextPage(_, _):
                    self?.projectsByUser? += paginationProjects.items ?? []
                case .refresh(_, _):
                    self?.projectsByUser = paginationProjects.items
                }
                
                // Empty state
                if self?.projectsByUser?.isEmpty == true {
                    self?.tableViewProjects.displayBackgroundMessage(message: "No team members found".localized)
                } else {
                    self?.tableViewProjects.dismissBackgroundMessage()
                }
                
                self?.totalPages = paginationProjects.pages ?? 1
                self?.currentPage = paginationProjects.currentPage ?? 1
                self?.tableViewProjects.reloadData()
                
            case .failure(let error):
                if error.asAFError?.responseCode == HttpStatusCode.forbidden.rawValue {
                    // Logout
                    self?.logout()
                } else {
                    self?.tableViewProjects.displayBackgroundMessage(message: "No team members found".localized)
                    MessageManager.shared.showBar(title: "Info", subtitle: "Cannot get members", type: .info, containsIcon: true, fromBottom: false)
                }
            }
        }
    }
}

extension ProjectsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projectsByUser?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ProjectTableViewCell.self)
        let project = self.projectsByUser?[indexPath.row]
        cell.setProjectValues(project)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = (self.projectsByUser?.count ?? 1) - 2
        let nextPage = self.currentPage + 1
        
        if indexPath.row == lastElement,
           nextPage <= self.totalPages {
            self.getProjectsByUser(.nextPage(nextPage, searchController.searchBar.text?.trim() ?? ""))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        
        // show list of people in the project
    }
}

extension ProjectsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.trim().isEmpty == false {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: searchBar)
            perform(#selector(self.reload), with: searchBar, afterDelay: 1.0)
        }
    }
    
    @objc func reload() {
        self.getProjectsByUser(.refresh(1, self.searchController.searchBar.text?.trim() ?? ""))
        self.refreshControl.endRefreshing()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.getProjectsByUser(.firstPage)
    }
}
