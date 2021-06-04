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
        self.enableSelectedColor()
        self.imageViewProject.cornerRadius(10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setProjectValues(_ project: Project?) {
        var title = ""
        let usersInProject: Int = (project?.users?.count ?? 1) - 1
        var numberOfUsers: String = ""
        if usersInProject == 1 {
            numberOfUsers = "Only you".localized
            title = numberOfUsers
        } else {
            numberOfUsers = "\(usersInProject) users"
            title =  numberOfUsers + " " + "and you"
        }
        let attributedMessage = NSMutableAttributedString(string: title)
        attributedMessage.setColor("you", color: .indigo(), font: UIFont(name: "Montserrat-MediumItalic", size: 12) ?? UIFont.systemFont(ofSize: 12))
        attributedMessage.setColor(numberOfUsers, color: .indigo(), font: UIFont(name: "Montserrat-MediumItalic", size: 12) ?? UIFont.systemFont(ofSize: 12))
        
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
