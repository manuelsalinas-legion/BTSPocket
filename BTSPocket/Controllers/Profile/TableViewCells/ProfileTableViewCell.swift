//
//  ProfileTableViewCell.swift
//  BTSPocket
//
//  Created by bts on 06/04/21.
//

import UIKit
import MessageUI

class ProfileTableViewCell: UITableViewCell, MFMailComposeViewControllerDelegate {
    
    // MARK:- Outlets
    @IBOutlet weak private var labelResume: UILabel!
    @IBOutlet weak private var labelLocation: UILabel!
    @IBOutlet weak private var labelEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileTableViewCell.tapFunction))
        self.labelEmail.isUserInteractionEnabled = true
        self.labelEmail.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated) }
    
    // MARK:- Functions
    /// Set backend Profile session data in profile section
    public func loadProfile(_ backendProfileData: ProfileData?) {
        self.labelResume?.text = backendProfileData?.description
        self.labelEmail?.text = backendProfileData?.email
        self.labelLocation?.text = backendProfileData?.location
    }
    
    @objc func tapFunction(sender: UITapGestureRecognizer) {
        if let url = URL(string: "mailto:\(self.labelEmail.text!)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
