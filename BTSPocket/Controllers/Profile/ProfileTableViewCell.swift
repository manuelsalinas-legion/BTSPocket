//
//  ProfileTableViewCell.swift
//  BTSPocket
//
//  Created by bts on 06/04/21.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    // MARK:- Outlets
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
        if let email = backendProfileData?.email,
           let resume = backendProfileData?.description,
           let location = backendProfileData?.location {
            self.labelResume?.text = resume
            self.labelEmail?.text = email
            self.labelLocation?.text = location
        }
    }
}
