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
    func setSkillsInRow(_ startingPosition: Int) {
        let first = (startingPosition * 3)
        let second = (startingPosition * 3) + 1
        let third = (startingPosition * 3) + 2
        self.labelSkill.text = BTSApi.shared.currentSession?.skills?[first].skill
        self.labelSkill2.text = BTSApi.shared.currentSession?.skills?[second].skill
        self.labelSkill3.text = BTSApi.shared.currentSession?.skills?[third].skill
    }
}
