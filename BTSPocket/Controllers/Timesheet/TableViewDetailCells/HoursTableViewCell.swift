//
//  TableViewHoursCell.swift
//  BTSPocket
//
//  Created by bts on 13/07/21.
//

import UIKit

class HoursTableViewCell: UITableViewCell {
    @IBOutlet weak var labelHours: UILabel!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var lableTitleHours: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
