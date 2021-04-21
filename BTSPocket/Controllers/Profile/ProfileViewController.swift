//
//  ProfileViewController.swift
//  BTSPocket
//
//  Created by bts on 25/03/21.
//

import UIKit

private enum ProfileSections: Int {
    case info = 0
    case skills = 1
    case experience = 2
}

class ProfileViewController: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelPosition: UILabel!
    @IBOutlet weak var labelField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // register table view cells for the table view
        self.tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        self.tableView.separatorStyle = .none
        setLabelsAndImage()
    }
    
    func setLabelsAndImage() {
        if let firstName = BTSApi.shared.profileSession?.firstName?.capitalized,
           let lastName = BTSApi.shared.profileSession?.lastName?.capitalized {
            self.labelFullName.text = firstName + " " + lastName
        }
        if let field = BTSApi.shared.profileSession?.field,
           let position = BTSApi.shared.profileSession?.position {
            self.labelField.text = field
            self.labelPosition.text = position
        }
        if let image = BTSApi.shared.profileSession?.photo {
            let urlImage = "https://s3.amazonaws.com/cdn.platform.bluetrail.software/prod/" + image
            self.imageProfile.loadProfileImage(urlString: urlImage)
        }
    }
    
    @IBAction func buttonLogout(_ sender: Any) {
        BTSApi.shared.deleteUserData()
    }
    
}

// MARK:- Table view data source
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if BTSApi.shared.profileSession?.skills?.isEmpty == false {
            if BTSApi.shared.profileSession?.experiences?.isEmpty == false {
                return 3
            } else {
                return 2
            }
        } else if BTSApi.shared.profileSession?.experiences?.isEmpty == false {
            if BTSApi.shared.profileSession?.skills?.isEmpty == false {
                return 3
            } else {
                return 2
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case ProfileSections.skills.rawValue:
            return "Skills"
        case ProfileSections.experience.rawValue:
            return "Experience"
        default:
            return ""
        }
    }
    
    // Number of row in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case ProfileSections.skills.rawValue:
            return BTSApi.shared.profileSession?.skills?.count ?? 0
        case ProfileSections.experience.rawValue:
            return BTSApi.shared.profileSession?.experiences?.count ?? 0
        default:
            return 1
        }
    }
    
    ///Return a default dequeueReusableCell unselectible
    func createDefaultCell() -> UITableViewCell {
        let defaultCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
        defaultCell.textLabel?.numberOfLines = 0
        defaultCell.setSelected(false, animated: false)
        defaultCell.isUserInteractionEnabled = false
        return defaultCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        // case resume or description
        case ProfileSections.info.rawValue:
            let customCell: ProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
            customCell.loadProfile(BTSApi.shared.profileSession)
            customCell.selectionStyle = .none
            return customCell
        //case skills
        case ProfileSections.skills.rawValue:
            let cell = createDefaultCell()
            cell.textLabel?.text = BTSApi.shared.profileSession?.skills?[indexPath.row].skill
            cell.textLabel?.font = UIFont(name: "Hiragino Sans", size: 13)
            return cell
        //case experiences
        case ProfileSections.experience.rawValue:
            let cell = createDefaultCell()
            if let postionCompany = BTSApi.shared.profileSession?.experiences?[indexPath.row].position,
               let companyExp = BTSApi.shared.profileSession?.experiences?[indexPath.row].company {
                cell.textLabel?.text = postionCompany.capitalized + " In " + companyExp.capitalized
            }
                
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case ProfileSections.skills.rawValue:
            if BTSApi.shared.profileSession?.skills?.isEmpty == false {
                return CGFloat(20)
            } else {
                return 0
            }
        case ProfileSections.experience.rawValue:
            if BTSApi.shared.profileSession?.experiences?.isEmpty == false {
                return CGFloat(20)
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .white
            headerView.textLabel?.font = UIFont.init(name: "Hiragino Sans", size: 18.0)
        }
    }
}
