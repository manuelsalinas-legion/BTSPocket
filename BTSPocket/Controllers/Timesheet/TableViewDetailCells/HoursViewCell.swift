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
    
    var onHourChange:((_ content: Int) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    func setup(_ setHours: Int) {
        self.intHours = setHours
        self.labelChanged(setHours)
    }
    
    ///show intHour in label and send the clousure
    func labelChanged(_ hours: Int) {
        self.labelHours.text = String(hours)
        self.onHourChange?(hours)
    }
    
    // MARK: BUTTON ACTIONS
    @IBAction func plusHour(_ sender: Any) {
        self.intHours +=  1
        labelChanged(self.intHours)
        if self.intHours < 24 {
            self.buttonPrevious.isEnabled = true
        } else {
            self.buttonNext.isEnabled = false
        }
    }
    
    @IBAction func lessHour(_ sender: Any) {
        self.intHours -=  1
        labelChanged(self.intHours)
        if self.intHours > 1 {
            self.buttonNext.isEnabled = true
        } else {
            self.buttonPrevious.isEnabled = false
        }
    }
}
