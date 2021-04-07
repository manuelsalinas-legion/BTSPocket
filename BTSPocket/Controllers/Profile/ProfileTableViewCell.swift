//
//  ProfileTableViewCell.swift
//  BTSPocket
//
//  Created by bts on 06/04/21.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    // MARK:- Outlets
    @IBOutlet weak private var imageProfile: UIImageView!
    @IBOutlet weak private var labelFullName: UILabel!
    @IBOutlet weak private var labelField: UILabel!
    @IBOutlet weak private var labelPosition: UILabel!
    @IBOutlet weak private var labelResume: UILabel!
    @IBOutlet weak private var labelLocation: UILabel!
    @IBOutlet weak private var labelEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib() }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated) }
    
    // MARK:- Functions
    /// Set backend Profile session data in profile section
    public func loadProfile(_ backendProfileData: ProfileData?) {
        if let firstName = backendProfileData?.firstName?.capitalized,
           let lastName = backendProfileData?.lastName?.capitalized {
            self.labelFullName?.text = firstName + " " + lastName
        }
        if let field = backendProfileData?.field?.capitalized,
           let position = backendProfileData?.position?.capitalized,
           let resume = backendProfileData?.description {
            self.labelField?.text = field
            self.labelPosition?.text = position
            self.labelResume?.text = resume
        }
        if let email = backendProfileData?.email,
           let location = backendProfileData?.location {
            self.labelEmail?.text = email
            self.labelLocation?.text = location
        }
        if backendProfileData?.photo != nil,
           let photo = backendProfileData?.photo {
//            print("https://s3.amazonaws.com/cdn.platform.bluetrail.software/dev/" + photo)
//            let url = URL(string:  "https://s3.amazonaws.com/cdn.platform.bluetrail.software/dev/" + photo)!
//            self.imageProfile.loadImage(url: url)
            self.imageProfile.image = UIImage(named: "logoBTS")
        }
    }
}
