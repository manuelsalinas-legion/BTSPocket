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
        if let email = backendProfileData?.email,
           let resume = backendProfileData?.description,
           let location = backendProfileData?.location {
            self.labelResume?.text = resume
            self.labelEmail?.text = email
            self.labelLocation?.text = location
        }
    }
    
    @objc func tapFunction(sender: UITapGestureRecognizer) {
        if let url = URL(string: "mailto:cristianp@bluetrailsoft.com") {
            print("Entra")
//            if UIApplication.shared.canOpenURL(url) {
                print("Entraasd")
                UIApplication.shared.openURL(url)
//            }
        }
//
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//        } else {
//           // Fallback on earlier versions
//            // dejar solo este, nunca sera menor a IOs 13
//            UIApplication.shared.openURL(url!)
//        }
    }
}