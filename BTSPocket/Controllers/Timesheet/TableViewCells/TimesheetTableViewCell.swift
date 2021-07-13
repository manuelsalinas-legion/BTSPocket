//
//  TimesheetTableViewCell.swift
//  BTSPocket
//
//  Created by bts on 27/06/21.
//

import UIKit

class TimesheetTableViewCell: UITableViewCell {

    @IBOutlet private weak var labelHours: UILabel!
    @IBOutlet private weak var labelTitle: UILabel!
    @IBOutlet private weak var labelSubtitle: UILabel!
    @IBOutlet private weak var imageViewIsHappy: UIImageView!
    @IBOutlet private weak var buttonNote: UIButton!
    @IBOutlet private weak var viewLeft: UIView!
    
    private var noteMessage: String?
    var onTapNote: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewLeft.addBorder(edges: [.right], color: .grayCity(), thickness: 1)
        self.labelTitle.textColor = .blueBelize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func noteClicked(_ sender: Any) {
        self.onTapNote?()
    }
    
    func setTimesheetValues(timesheetDescription: TimesheetDescription?) {
        self.labelHours?.text = String(timesheetDescription?.dedicatedHours ?? 0)
        self.labelTitle?.text = timesheetDescription?.projectName?.capitalized
        self.labelSubtitle?.text = timesheetDescription?.task
        self.noteMessage = timesheetDescription?.note
        self.imageViewIsHappy?.image = timesheetDescription?.isHappy ?? true ? #imageLiteral(resourceName: "iconHappy") : #imageLiteral(resourceName: "iconSad")
        self.buttonNote.isHidden = timesheetDescription?.note?.isEmpty ?? true ? true : false
    }
}
