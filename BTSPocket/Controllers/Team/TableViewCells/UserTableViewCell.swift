//
//  UserTableViewCell.swift
//  BTSPocket
//
//  Created by bts on 27/04/21.
//

import UIKit
import Kingfisher

enum typeOfUser {
    case user(User?)
    case projectUser(UserInProject?)
}

class UserTableViewCell: UITableViewCell {

    // MARK:- Outlets and Variables
    @IBOutlet weak private var imageViewUser: UIImageView!
    @IBOutlet weak private var labelFullName: UILabel!
    @IBOutlet weak private var labelPosition: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addStyleImage()
        self.enableSelectedColor()
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
    public func setUserInfo(_ mode: typeOfUser) {
        switch mode {
        case .user(let user):
            self.labelFullName.text = user?.fullName
            self.labelPosition.text = user?.seniorityPosition?.capitalized
            // obtaining photo
            if let photoPath = user?.photo {
                let url = URL(string: Constants.urlBucketImages + photoPath)
                // adding header in request.
                let modifier = AnyModifier { request in
                    var mutableRequest = request
                    mutableRequest.setValue(Constants.serverAddress, forHTTPHeaderField: "Referer")
                    return mutableRequest
                }
                self.imageViewUser.kf.indicatorType = .activity
                self.imageViewUser.kf.setImage(with: url,
                                               placeholder: UIImage(named: "placeholderUser"),
                                               options: [
                                                .requestModifier(modifier),
                                                .processor(DownsamplingImageProcessor(size: self.imageViewUser.frame.size)),
                                                .scaleFactor(UIScreen.main.scale),
                                                .cacheOriginalImage
                                               ])
                
            }
        case .projectUser(let projectUser):
            self.labelFullName.text = projectUser?.fullName
            self.labelPosition.text = projectUser?.projectRole
            // obtaining photo
            if let photoPath = projectUser?.photo {
                let url = URL(string: Constants.urlBucketImages + photoPath)
                // adding header in request.
                let modifier = AnyModifier { request in
                    var mutableRequest = request
                    mutableRequest.setValue(Constants.serverAddress, forHTTPHeaderField: "Referer")
                    return mutableRequest
                }
                self.imageViewUser.kf.indicatorType = .activity
                self.imageViewUser.kf.setImage(with: url,
                                               placeholder: UIImage(named: "placeholderUser"),
                                               options: [
                                                .requestModifier(modifier),
                                                .processor(DownsamplingImageProcessor(size: self.imageViewUser.frame.size)),
                                                .scaleFactor(UIScreen.main.scale),
                                                .cacheOriginalImage
                                               ])
                
            }
        }
    }
}
