//
//  ProfileViewController.swift
//  BTSPocket
//
//  Created by bts on 25/03/21.
//

import UIKit
import Kingfisher

private enum ProfileSections: Int {
    case info, skills, experience
}

enum ProfileScreenType {
    case myProfile, teamMember
}

class ProfileViewController: UIViewController {
    
    // MARK:- Outlets & Variables
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelPosition: UILabel!
    @IBOutlet weak var labelField: UILabel!
    @IBOutlet weak var buttonLogout: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    
    private var profileVM: ProfileViewModel = ProfileViewModel()
    private var profile: ProfileData? {
        didSet {
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }
    private var currentUser: ProfileData? {
        self.typeUser()
    }
    var mode: ProfileScreenType = .myProfile
    var memberId: Int?
    
    // MARK:- life cicle func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        switch mode {
        case .myProfile:
            
            // Logged user
            if let loggedSession = BTSApi.shared.currentSession {
                self.profile = loggedSession
                self.setupProfile()
            }
            
            // Update info
            self.getProfile()
            
        case .teamMember:
            self.memberConfiguration()
            self.getMemberProfile()
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK:- memberConfiguration function
    // hidde the logout button and add back button
    private func memberConfiguration() {
        self.buttonLogout.isHidden = true
        self.buttonBack.isHidden = false
        self.buttonBack.backgroundColor = UIColor.semiblackColor()
        self.buttonBack.round()
        
    }
    
    // MARK:- getMemberProfile function
    private func getMemberProfile() {
        self.profileVM.getMemberProfile(memberId, { result in
            switch result {
            case .success(let member):
                self.profile = member
                self.setupProfile()
            case .failure(let error):
                if error.asAFError?.responseCode == HttpStatusCode.unauthorized.rawValue {
                    BTSApi.shared.deleteSession()
                    self.showLogin()
                } else {
                    self.showGenericErrorAlert("Error", "Generic Error", "OK")
                }
            }
        })
    }
    
    // MARK:- setUpTable
    private func setupUI() {
        // UI
        self.labelFullName.adjustsFontSizeToFitWidth = true
        self.buttonLogout.round()
        self.buttonLogout.backgroundColor = UIColor.semiblackColor()
        
        // register table view cells for the table view
        self.tableView.registerNib(ProfileTableViewCell.self)
        self.tableView.registerNib(SkillsTableViewCell.self)
        self.tableView.separatorStyle = .none
    }
    
    // MARK: WEB SERVICE
    private func getProfile() {
                
        self.profileVM.getProfile { [weak self] error in
            
            if let error = error {
                // Expired session?
                if error.code == HttpStatusCode.unauthorized.rawValue {
                    BTSApi.shared.deleteSession()
                    self?.showLogin()
                } else {
                    print(error.localizedDescription)
                    MessageManager.shared.showBar(title: "Error", subtitle: "Profile update failed.  Please, try again.", type: .error, containsIcon: true, fromBottom: false)
                }
            } else {
                self?.setupProfile()
            }
        }
    }
    
    // MARK:- setUptProfile function
    private func setupProfile() {
        // Titles
        self.labelFullName.text = self.currentUser?.fullName
        self.labelField.text = self.currentUser?.field
        self.labelPosition.text = self.currentUser?.position
        
        // Profile Picture
        if let image = self.currentUser?.photo {
            let url = URL(string: Constants.urlBucketImages + image)
            // adding header in request
            let modifier = AnyModifier { request in
                var mutableRequest = request
                mutableRequest.setValue(Constants.serverAddress, forHTTPHeaderField: "Referer")
                return mutableRequest
            }
            self.imageViewProfile.kf.indicatorType = .activity
            self.imageViewProfile.kf.setImage(with: url,
                                              placeholder: UIImage(named: "placeholderUser"),
                                              options: [
                                                .requestModifier(modifier),
                                                .processor(DownsamplingImageProcessor(size: self.imageViewProfile.frame.size)),
                                                .scaleFactor(UIScreen.main.scale),
                                                .cacheOriginalImage
                                              ])
        }
    }
    
    // MARK:- type of user function
    ///Check the mode enum to return the current user session or a member data
    private func typeUser() -> ProfileData? {
        switch self.mode {
        case .myProfile:
            return BTSApi.shared.currentSession
        case .teamMember:
            return self.profile
        }
    }
    
    // MARK:- Logout funtion
    @IBAction func buttonLogout(_ sender: Any) {
        
        // Alert confirmation
        let alert = UIAlertController(title: "Logout", message: "Would you like to close your account session?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes, Logout", style: .default, handler: { [weak self  ] _ in
            // Logout
            BTSApi.shared.deleteSession()
            self?.showLogin()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Back button action
    @IBAction private func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TABLE VIEW (UITableViewDataSource & UITableViewDelegate)
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.currentUser?.skills?.isEmpty == false {
            return self.currentUser?.experiences?.isEmpty == false ? 3 : 2
        } else if self.currentUser?.experiences?.isEmpty == false {
            return self.currentUser?.skills?.isEmpty == false ? 3 : 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case ProfileSections.skills.rawValue:
            return self.createHeader(title: "Skills".localized)
        case ProfileSections.experience.rawValue:
            return self.createHeader(title: "Experience".localized)
        default:
            return nil
        }
    }
    
    // Number of row in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case ProfileSections.skills.rawValue:
            let skills = self.currentUser?.skills?.count ?? 0
            let divition = Double(skills) / 3
            
            return Int(divition.rounded(.up))
            
        case ProfileSections.experience.rawValue:
            return self.currentUser?.experiences?.count ?? 0 >= 2 ? 2 : self.currentUser?.experiences?.count ?? 0
        default:
            return 1
        }
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        // case resume or description
        case ProfileSections.info.rawValue:
            let customCell: ProfileTableViewCell = tableView.dequeueReusableCell(withClass: ProfileTableViewCell.self)
            customCell.selectionStyle = .none
            customCell.loadProfile(self.currentUser)
            return customCell
            
        //case skills
        case ProfileSections.skills.rawValue:
            let customSkillsCell: SkillsTableViewCell = tableView.dequeueReusableCell(withClass: SkillsTableViewCell.self)
            customSkillsCell.setSkillsInRow(self.currentUser, indexPath.row)
            customSkillsCell.selectionStyle = .none
            return customSkillsCell
            
        //case experiences
        case ProfileSections.experience.rawValue:
            let cell = createDefaultCell()
            if let postionCompany = self.currentUser?.experiences?[indexPath.row].position,
               let companyExp = self.currentUser?.experiences?[indexPath.row].company {
                cell.textLabel?.text = postionCompany.capitalized + " At " + companyExp.capitalized
            }
            cell.textLabel?.font = UIFont(name: "Hiragino Maru Gothic ProN", size: 15.0)
            cell.textLabel?.lineBreakMode = .byCharWrapping
            cell.textLabel?.numberOfLines = 3
            cell.textLabel?.textColor = UIColor.systemGray
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case ProfileSections.skills.rawValue:
            return self.currentUser?.skills?.isEmpty == false ? 35 : .leastNormalMagnitude
        case ProfileSections.experience.rawValue:
            return self.currentUser?.experiences?.isEmpty == false ? 35 : .leastNormalMagnitude
        default:
            return .leastNormalMagnitude
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
    
    // MARK: HELPERS
    private func createHeader(title: String) -> UILabel {
        let lblSectionTitle = UILabel()
        lblSectionTitle.text = "     " + title
        lblSectionTitle.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        return lblSectionTitle
    }
    
    func createDefaultCell() -> UITableViewCell {
        let defaultCell = UITableViewCell(style: .default, reuseIdentifier: "DefaultCell")
        defaultCell.textLabel?.numberOfLines = 0
        defaultCell.setSelected(false, animated: false)
        defaultCell.isUserInteractionEnabled = false
        return defaultCell
    }
}
