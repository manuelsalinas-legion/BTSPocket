//
//  TimesheetViewController.swift
//  BTSPocket
//
//  Created by bts on 25/03/21.
//

import UIKit
import JTAppleCalendar

class TimesheetViewController: UIViewController {
    
    @IBOutlet weak var calendar: JTACMonthView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Timesheet".localized
        self.setupCalendarView()
    }
    
    func setupCalendarView() {
        self.calendar.minimumLineSpacing = 0
        self.calendar.minimumInteritemSpacing = 0
        self.calendar.showsHorizontalScrollIndicator = false
        self.calendar.scrollingMode = .stopAtEachCalendarFrame
        self.calendar.scrollDirection = .horizontal
    }
    
    
    @IBAction private func nextWeek(_ sender: Any) {
        self.calendar.scrollToSegment(.next)
    }
    
    @IBAction private func previousWeek(_ sender: Any) {
        self.calendar.scrollToSegment(.previous)
    }
}
extension TimesheetViewController: JTACMonthViewDelegate, JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let startDate = formatter.date(from: "2021 01 01")!
        let endDate = formatter.date(from: "2021 12 31")!
    
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate,
                                       numberOfRows: 1,
                                       generateInDates: .forFirstMonthOnly,
                                       generateOutDates: .off,
                                       firstDayOfWeek: .monday,
                                       hasStrictBoundaries: false)
    }
    
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        cell.dayOfWeekLabel.text = String("\(cellState.day)".prefix(3)).capitalized
        
        
        
        configureColorCell(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarCell else { return }
        cell.dateLabel.text = cellState.text
        configureColorCell(cell: cell, cellState: cellState)
    }
    
    private func addStatusLabel(cell: JTACDayCell?, cellState: CellState) {
        guard let cell = cell as? CalendarCell else { return }
        cell.dateLabel.text = cellState.text
        
    }
    
    private func configureColorCell(cell: JTACDayCell?, cellState: CellState) {
        guard let cell = cell as? CalendarCell else { return }
        cell.dateLabel.text = cellState.text
        
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
        } else {
            cell.dateLabel.textColor = UIColor.red
        }
    }
}
