//
//  UserTableViewCell.swift
//  BTSPocket
//
//  Created by bts on 27/04/21.
//

import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {

    // MARK:- Outlets and Variables
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelPosition: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addStyleImage()
    }
    
    func addStyleImage() {
        DispatchQueue.main.async {
            self.imageViewUser.round()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK:- set user information function
    public func setUserInfo(_ user: User?) {
        self.labelFullName.text = user?.fullName
        self.labelPosition.text = user?.seniorityPosition?.capitalized
        // obtaining photo
        if let photoPath = user?.photo {
            let url = URL(string: Constants.urlBucketImages + photoPath)
            // adding header in request.
            let modifier = AnyModifier { request in
                var r = request
                r.setValue(Constants.serverAddress, forHTTPHeaderField: "Referer")
                return r
            }
            self.imageViewUser.kf.setImage(with: url, placeholder: UIImage(named: "placeholderUser"), options: [.requestModifier(modifier)])
        }
    }
}
