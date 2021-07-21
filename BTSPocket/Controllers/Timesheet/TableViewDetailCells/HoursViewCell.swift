//
//  TableViewHoursCell.swift
//  BTSPocket
//
//  Created by bts on 13/07/21.
//

import UIKit

class HoursViewCell: UITableViewCell {
    //MARK: OUTLETS AND VARIABLES
    @IBOutlet weak var labelHours: UILabel!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var lableTitleHours: UILabel!
    private var intHours: Int = 8
    private var maxHours: Int = 24
    private var workedHours: Int = 0
    var onHourChange:((_ content: Int) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: SETUP MODES
    ///hide the buttons that change the labels
    func detailsMode() {
        self.buttonNext.isHidden = true
        self.buttonPrevious.isHidden = true
    }
    
    ///Set int and label hours
    func setup(_ info: TimesheetDetail?) {
        let hoursFiltered = info?.timesheets?.descriptions?.map({
            Int( $0.dedicatedHours ?? 0)
        })
        guard let totalWorkedHours = hoursFiltered?.reduce(0, +) else {
            labelChanged(8)
            return
        }
        self.workedHours = totalWorkedHours
        self.maxHours = 24 - totalWorkedHours
        self.labelChanged(totalWorkedHours > 16 ? self.maxHours : totalWorkedHours < 8 ? 8 - totalWorkedHours : 1)
    }
    
    ///show intHour in label and send the clousure
    func labelChanged(_ hours: Int) {
        self.intHours = hours
        self.labelHours.text = String(hours)
        self.onHourChange?(hours)
        self.buttonNext.isEnabled = (self.workedHours + self.intHours) == 24 ? false : true
        self.buttonPrevious.isEnabled = self.intHours == 1 ? false : true
    }
    
    // MARK: BUTTON ACTIONS
    @IBAction func plusHour(_ sender: Any) {
        labelChanged(self.intHours + 1)
        if self.intHours < 24 {
            self.buttonPrevious.isEnabled = true
        } else {
            self.buttonNext.isEnabled = false
        }
    }
    
    @IBAction func lessHour(_ sender: Any) {
        labelChanged(self.intHours - 1)
        if self.intHours > 1 {
            self.buttonNext.isEnabled = true
        } else {
            self.buttonPrevious.isEnabled = false
        }
    }
}
