//
//  SkillsTableViewCell.swift
//  BTSPocket
//
//  Created by bts on 22/04/21.
//

import UIKit

class SkillsTableViewCell: UITableViewCell {

    // MARK:- Outlets
    @IBOutlet weak var labelSkill: UILabel!
    @IBOutlet weak var labelSkill2: UILabel!
    @IBOutlet weak var labelSkill3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    ///Set up stack of labels
    func setSkillsInRow(_ currentUser: ProfileData?, _ startingPosition: Int) {
        let first = (startingPosition * 3)
        let second = (startingPosition * 3) + 1
        let third = (startingPosition * 3) + 2
        if let skillOne = currentUser?.skills?[first].skill {
            self.labelSkill?.text = skillOne
        }
        if currentUser?.skills?.indices.contains(second) == true,
            let skillTwo = currentUser?.skills?[second].skill {
            self.labelSkill2?.text = skillTwo
        } else {
            self.labelSkill2?.removeFromSuperview()
        }
        if currentUser?.skills?.indices.contains(third) == true,
            let skillThree = currentUser?.skills?[third].skill {
            self.labelSkill3?.text = skillThree
        } else {
            self.labelSkill3?.removeFromSuperview()
        }
    }
}
