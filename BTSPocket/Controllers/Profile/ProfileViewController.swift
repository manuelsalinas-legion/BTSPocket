//
//  ProfileViewController.swift
//  BTSPocket
//
//  Created by bts on 25/03/21.
//

import UIKit

private enum ProfileSections: String, CaseIterable {
    case basicInfo = "INFO"
    case skills = "SKILLS"
    case experience = "EXPERIENCE"
}

class ProfileViewController: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // register table view cells for the table view
        self.tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
}

// MARK:- Table view data source
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if BTSApi.shared.profileSession?.skills?.count ?? 0 > 0 {
            if BTSApi.shared.profileSession?.experiences?.count ?? 0 > 0 {
                return 3
            } else {
                return 2
            }
        } else if BTSApi.shared.profileSession?.experiences?.count ?? 0 > 0 {
            if BTSApi.shared.profileSession?.skills?.count ?? 0 > 0 {
                return 3
            } else {
                return 2
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch ProfileSections.allCases[section].rawValue {
        case "INFO":
            return ""
        case "SKILLS":
            return "Skills"
        case "EXPERIENCE":
            return "Experience"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch ProfileSections.allCases[section].rawValue {
        case "INFO":
            return 1
        case "SKILLS":
            return BTSApi.shared.profileSession?.skills?.count ?? 0
        case "EXPERIENCE":
            return BTSApi.shared.profileSession?.experiences?.count ?? 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch ProfileSections.allCases[indexPath.section].rawValue {
        case "INFO":
            let profileTableCell: ProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell;
            profileTableCell.loadProfile(BTSApi.shared.profileSession)
            return profileTableCell
            
        case "SKILLS":
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
            cell.textLabel?.text = BTSApi.shared.profileSession?.skills?[indexPath.row].skill
            cell.textLabel?.numberOfLines = 0
            cell.setSelected(false, animated: false)
            cell.isUserInteractionEnabled = false
            return cell
            
        case "EXPERIENCE":
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
            cell.textLabel?.text = BTSApi.shared.profileSession?.experiences?[indexPath.row].position
            cell.textLabel?.numberOfLines = 0
            cell.setSelected(false, animated: false)
            cell.isUserInteractionEnabled = false
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch ProfileSections.allCases[section].rawValue {
        case "INFO":
            return 0
        case "SKILLS":
            if BTSApi.shared.profileSession?.skills?.count ?? 0 > 0 {
                return CGFloat(20)
            } else {
                return 0
            }
        case "EXPERIENCE":
            if BTSApi.shared.profileSession?.experiences?.count ?? 0 > 0 {
                return CGFloat(20)
            } else {
                return 0
            }
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .white
            headerView.textLabel?.font = UIFont.init(name: "Galvji Bold", size: 23.0)
        }
    }
}
