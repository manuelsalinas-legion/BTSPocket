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
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var imageViewIsHappy: UIImageView!
    @IBOutlet weak var buttonNote: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setTimesheetValues(timesheetDescription: TimesheetDescription?) {
        self.labelHours?.text = String(timesheetDescription?.dedicatedHours ?? 0)
        self.labelTitle?.text = timesheetDescription?.projectName
        self.labelSubtitle?.text = timesheetDescription?.task
        self.imageViewIsHappy?.image = timesheetDescription?.isHappy ?? true ? #imageLiteral(resourceName: "iconHappy") : #imageLiteral(resourceName: "iconSad")
        self.buttonNote.isHidden = timesheetDescription?.note?.isEmpty ?? true ? true : false
    }
}
