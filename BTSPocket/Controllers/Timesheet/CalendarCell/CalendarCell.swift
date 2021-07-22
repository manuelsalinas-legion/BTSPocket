//
//  CalendarCell.swift
//  BTSPocket
//
//  Created by bts on 17/06/21.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTACDayCell {
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var statusDotView: UIView!
    
    override func awakeFromNib() {
        self.selectedView.backgroundColor = UIColor.daySelection()
        self.statusDotView.round()
    }
}
