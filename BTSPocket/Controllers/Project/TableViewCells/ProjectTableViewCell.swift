//
//  ProjectTableViewCell.swift
//  BTSPocket
//
//  Created by bts on 20/05/21.
//

import UIKit
import Kingfisher

class ProjectTableViewCell: UITableViewCell {

    // MARK: Outlets and variables
    @IBOutlet weak var imageViewProject: UIImageView!
    @IBOutlet weak var labelNameProject: UILabel!
    @IBOutlet weak var labelCountUsers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setProjectValues(_ project: Project?) {
        var countUsersMessage: String?
        let countUsers = (project?.users?.count ?? 1) - 1
        if countUsers == 1 {
            countUsersMessage = "Only You"
        } else {
            countUsersMessage = "\(countUsers) users and you"
        }
        self.labelNameProject.text = project?.name
        self.labelCountUsers.text = countUsersMessage
        if let photoPath = project?.image {
            let url = URL(string: Constants.urlBucketImages + photoPath)
            // adding header in request.
            let modifier = AnyModifier { request in
                var mutableRequest = request
                mutableRequest.setValue(Constants.serverAddress, forHTTPHeaderField: "Referer")
                return mutableRequest
            }
            self.imageViewProject.kf.indicatorType = .activity
            self.imageViewProject.kf.setImage(with: url,
                                           placeholder: UIImage(named: "placeholderUser"),
                                           options: [
                                            .requestModifier(modifier),
                                            .processor(DownsamplingImageProcessor(size: self.imageViewProject.frame.size)),
                                            .scaleFactor(UIScreen.main.scale),
                                            .cacheOriginalImage
                                           ])
        }
        
    }
    
}
