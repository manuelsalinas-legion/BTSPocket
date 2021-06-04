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
    @IBOutlet weak private var imageViewProject: UIImageView!
    @IBOutlet weak private var labelNameProject: UILabel!
    @IBOutlet weak private var labelCountUsers: UILabel!
    
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
        let attributedMessage = NSMutableAttributedString(string: countUsersMessage!)
        attributedMessage.setColor(countUsersMessage!, color: .btsBlue())
        
        self.labelNameProject.text = project?.name?.capitalized
        self.labelCountUsers.attributedText = attributedMessage
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
                                           placeholder: UIImage(named: "placeholderProject"),
                                           options: [
                                            .requestModifier(modifier),
                                            .processor(DownsamplingImageProcessor(size: self.imageViewProject.frame.size)),
                                            .scaleFactor(UIScreen.main.scale),
                                            .cacheOriginalImage
                                           ])
        } else {
            DispatchQueue.main.async {
                self.imageViewProject.image = UIImage(named: "placeholderProject")
                self.imageViewProject.contentMode = .scaleToFill
            }
        }
        
    }
    
}
