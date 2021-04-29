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
    
    // MARK:- Outlets & Variables
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelPosition: UILabel!
    @IBOutlet weak var labelField: UILabel!
    
    private var profileVM: ProfileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileVM = ProfileViewModel()
        self.setUpProfile()
        self.updateProfileData() 
    }
    
    // MARK:- functions
    func updateProfileData() {
        self.profileVM?.getProfile({ [weak self] error in
            if let error = error {
                if error.code == HttpStatusCode.unauthorized.rawValue {
                    BTSApi.shared.deleteSession()
                    self?.showLogin()
                } else {
                    let alert = UIAlertController(title: "Server error", message: "We are experimented server issues please try again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "CERRAR", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
            self?.setUpProfile()
        })
    }
    // MARK:- setUpt function
    func setUpProfile() {
        // register table view cells for the table view
        self.tableView.registerNib(ProfileTableViewCell.self)
        self.tableView.registerNib(SkillsTableViewCell.self)
        self.tableView.separatorStyle = .none
        // set text in labels text
        self.labelFullName.text = BTSApi.shared.currentSession?.fullName
        self.labelField.text = BTSApi.shared.currentSession?.field?.capitalized
        self.labelPosition.text = BTSApi.shared.currentSession?.position
        if let image = BTSApi.shared.currentSession?.photo {
            let urlImage = Constants.urlBucketImages + image
            self.imageProfile.loadProfileImage(urlString: urlImage)
        }
    }
    
    // MARK:- Logout funtion
    @IBAction func buttonLogout(_ sender: Any) {
        //Here call to method of delete all data and send to loguin
        BTSApi.shared.deleteSession()
        self.showLogin()
    }
    
}

// MARK:- Table view data source
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if BTSApi.shared.currentSession?.skills?.isEmpty == false {
            if BTSApi.shared.currentSession?.experiences?.isEmpty == false {
                return 3
            } else {
                return 2
            }
        } else if BTSApi.shared.currentSession?.experiences?.isEmpty == false {
            if BTSApi.shared.currentSession?.skills?.isEmpty == false {
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
            let countSkills = BTSApi.shared.currentSession?.skills?.count ?? 0
            return Int(round(Double(countSkills / 3)))
        case ProfileSections.experience.rawValue:
            if BTSApi.shared.currentSession?.experiences?.count ?? 0 >= 2 {
                return 2
            } else {
                return BTSApi.shared.currentSession?.experiences?.count ?? 0
            }
        default:
            return 1
        }
    }
    // MARK:- default cell function for cellForRowAt
    ///Return a default dequeueReusableCell unselectible
    func createDefaultCell() -> UITableViewCell {
        let defaultCell = UITableViewCell(style: .default, reuseIdentifier: "DefaultCell")
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
                customCell.selectionStyle = .none
                customCell.loadProfile(BTSApi.shared.currentSession)
                return customCell
                
            //case skills
            case ProfileSections.skills.rawValue:
                let customSkillsCell: SkillsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SkillsTableViewCell") as! SkillsTableViewCell
                customSkillsCell.setSkillsInRow(indexPath.row)
                customSkillsCell.selectionStyle = .none
                return customSkillsCell
                
            //case experiences
            case ProfileSections.experience.rawValue:
                let cell = createDefaultCell()
                if let postionCompany = BTSApi.shared.currentSession?.experiences?[indexPath.row].position,
                   let companyExp = BTSApi.shared.currentSession?.experiences?[indexPath.row].company {
                    cell.textLabel?.text = postionCompany.capitalized + " At " + companyExp.capitalized
                }
                cell.textLabel?.font = UIFont(name: "Hiragino Maru Gothic ProN", size: 15.0)
                cell.textLabel?.lineBreakMode = .byCharWrapping
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.textColor = UIColor.systemGray
                    
                return cell
            default:
                return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            case ProfileSections.skills.rawValue:
                return CGFloat(25)
            case ProfileSections.experience.rawValue:
                return CGFloat(35)
            default:
                return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case ProfileSections.skills.rawValue:
            if BTSApi.shared.currentSession?.skills?.isEmpty == false {
                return CGFloat(35)
            } else {
                return 0
            }
        case ProfileSections.experience.rawValue:
            if BTSApi.shared.currentSession?.experiences?.isEmpty == false {
                return CGFloat(35)
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
            headerView.textLabel?.font = UIFont.init(name: "Hiragino Maru Gothic ProN", size: 18.0)
            headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            headerView.textLabel?.textColor = UIColor(named: "Purple BTS")
        }
    }
}
