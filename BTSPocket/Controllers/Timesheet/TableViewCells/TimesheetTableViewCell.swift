//
//  TimesheetTableViewCell.swift
//  BTSPocket
//
//  Created by bts on 27/06/21.
//

import UIKit

class TimesheetTableViewCell: UITableViewCell {

    @IBOutlet weak var labelHours: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setTimesheetValues(timesheetDescription: TimesheetDescription?) {
        self.labelHours?.text = String(timesheetDescription?.dedicatedHours ?? 0)
        self.labelTitle?.text = timesheetDescription?.projectName
    }
}
