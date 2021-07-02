//
//  TimesheetViewController.swift
//  BTSPocket
//
//  Created by bts on 25/03/21.
//

import UIKit
import JTAppleCalendar
import SwiftDate

enum StatusTimesheet: Int {
    case empty, incomplete, complete, extraHours
}

class TimesheetViewController: UIViewController, UINavigationBarDelegate {
    
    // MARK:- Outlets and variables
    @IBOutlet weak private var calendarView: JTACMonthView!
    @IBOutlet weak private var headerCalendarLabel: UIButton!
    @IBOutlet weak var TableViewTimesheets: UITableView!
    private var timesheetVM = TimesheetViewModel()
    private var weekTimesheets: [GetTimesheets]?
    private var selectedDate: Date?
    
    
    // MARK:- life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Timesheet".localized
        self.setupCalendarView()
    }
    
    // MARK:- setup UI calendar
    private func setupCalendarView() {
        self.calendarView.minimumLineSpacing = 0
        self.calendarView.minimumInteritemSpacing = 0
        self.calendarView.showsHorizontalScrollIndicator = false
        self.calendarView.scrollingMode = .stopAtEachCalendarFrame
        self.calendarView.scrollDirection = .horizontal
        self.calendarView.allowsMultipleSelection = false
        self.calendarView.scrollToDate(Date(), animateScroll: false)
        self.calendarView.selectDates([Date()])
    }
    
    // MARK:- WEB SERVICE
    private func getTimesheets(_ visibleDates: DateSegmentInfo) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        guard let firstVisibleDate = visibleDates.monthDates.first?.date,
              let lastVisibleDate = visibleDates.monthDates.last?.date else {
            return
        }
        let startDate = dateFormatter.string(from: firstVisibleDate)
        let endDate = dateFormatter.string(from: lastVisibleDate)
        
        self.timesheetVM.getUserTimesheets(startDate, endDate) { [weak self] response in
            switch response {
            case .success(let timesheets):
                self?.weekTimesheets = timesheets
                self?.calendarView.reloadData()
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK:- IBAcctions
    @IBAction private func nextWeek(_ sender: Any) {
        self.calendarView.deselectAllDates()
        self.calendarView.scrollToSegment(.next) {
            self.calendarView.selectDates([ self.calendarView.visibleDates().monthDates[0].date ])
        }
    }
    
    @IBAction private func previousWeek(_ sender: Any) {
        self.calendarView.deselectAllDates()
        self.calendarView.scrollToSegment(.previous) {
            self.calendarView.selectDates([ self.calendarView.visibleDates().monthDates[0].date ])
        }
    }
    
    @IBAction func showToday(_ sender: Any) {
        self.calendarView.scrollToDate(Date(), animateScroll: true)
        self.calendarView.deselectAllDates()
        self.calendarView.selectDates([Date()])
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let dateSelectedString = dateFormatter.string(from: Date())
        self.headerCalendarLabel.setTitle(dateSelectedString, for: .normal)
    }
}

// MARK:- JTACMonthViewDelegate and JTACMonthViewDataSource
extension TimesheetViewController: JTACMonthViewDelegate, JTACMonthViewDataSource {
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        var dateComponents = DateComponents()
        dateComponents.month = -6
        let startDate = Calendar.current.date(byAdding: dateComponents, to: Date())!
        dateComponents.month = 3
        let endDate = Calendar.current.date(byAdding: dateComponents, to: Date())!
        
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate,
                                       numberOfRows: 1,
                                       generateInDates: .forFirstMonthOnly,
                                       generateOutDates: .off,
                                       firstDayOfWeek: .monday,
                                       hasStrictBoundaries: false)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        guard let calendarCell = calendarView.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else { return JTACDayCell() }
//        calendarCell.isHidden = cellState.isSelected ? false : true
        
        if cellState.isSelected {
            self.selectedDate = cellState.date
            calendarCell.selectedView.isHidden = false
        } else {
            calendarCell.selectedView.isHidden = true
        }

        calendarCell.dayOfWeekLabel.text = String("\(cellState.day)".prefix(3)).capitalized
        let attributedDayText = NSMutableAttributedString(string: cellState.text)
        let order = Calendar.current.compare(cellState.date, to: Date(), toGranularity: .day)
        if order == .orderedSame {
            attributedDayText.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: NSRange(location: 0, length: attributedDayText.string.count))
        }
        calendarCell.dateLabel.attributedText = attributedDayText
        switch self.checkTimesheetDayAndFullColor(calendarCell, cellState) {
        case .empty:
            calendarCell.colorView.backgroundColor = .lightGray
        case .incomplete:
            calendarCell.colorView.backgroundColor = .yellow
        case .complete:
            calendarCell.colorView.backgroundColor = .green
        case .extraHours:
            calendarCell.colorView.backgroundColor = .orange
        }
        return calendarCell
    }
    
    func checkTimesheetDayAndFullColor(_ calendarCell: CalendarCell, _ cellState: CellState) -> StatusTimesheet {
        var status: StatusTimesheet = .incomplete
        for registerTimesheet in weekTimesheets ?? [] {
            if let timesheetDate = registerTimesheet.date {
                
                let formatter = DateFormatter()
                let timesheetIsoDate = timesheetDate.toISODate()?.date
                
                var workedHours = 0
                
                if cellState.date.day == timesheetIsoDate?.day {
                    for descriptionTimesheet: TimesheetDescription in registerTimesheet.descriptions ?? [] {
                        if let dedicatedHours = descriptionTimesheet.dedicatedHours {
                            workedHours += dedicatedHours
                        }
                    }
                }
                
                if workedHours == 0 {
                    status = .empty
                } else if workedHours < Constants.hoursWorkingDay {
                    status = .incomplete
                } else if workedHours == Constants.hoursWorkingDay {
                    status = .complete
                } else if workedHours > Constants.hoursWorkingDay {
                    status = .extraHours
                }
            }
        }
        return status
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let calendarCell = cell as? CalendarCell else { return }
        calendarCell.selectedView.isHidden = false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let dateSelectedString = dateFormatter.string(from: date)
        self.headerCalendarLabel.setTitle(dateSelectedString, for: .normal)
        
        self.selectedDate = date
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let calendarCell = cell as? CalendarCell else { return }
        calendarCell.selectedView.isHidden = true
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.calendarView.selectDates([ visibleDates.monthDates[0].date ])
        self.getTimesheets(visibleDates)
    }
    
    func calendar(_ calendar: JTACMonthView, willScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.calendarView.deselectAllDates()
    }
}

extension TimesheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekTimesheets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("cellfor row")
        return UITableViewCell()
    }
    
}
