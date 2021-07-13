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
    
    // MARK: Outlets and variables
    @IBOutlet weak private var calendarView: JTACMonthView!
    @IBOutlet weak private var headerCalendarMonthLabel: UIButton!
    @IBOutlet weak private var weekViewStackView: UIStackView!
    @IBOutlet weak var tableTimesheets: UITableView!
    
    private let alertService = AlertService()
    private var timesheetVM = TimesheetViewModel()
    private var weekTimesheets: [GetTimesheets]? {
        didSet {
            DispatchQueue.main.async {
                self.calendarView.reloadData()
            }
        }
    }
    private var dayTimesheets: GetTimesheets? {
        didSet {
            DispatchQueue.main.async {
                self.tableTimesheets.reloadData()
            }
        }
    }
    private var selectedDate: Date? {
        didSet {
            for (index, timesheetRegister) in self.weekTimesheets?.enumerated() ?? [].enumerated() {
                if self.selectedDate?.day == timesheetRegister.date?.toISODate()?.date.day {
                    self.dayTimesheets = self.weekTimesheets![index]
                    break
                } else {
                    self.dayTimesheets = nil
                }
            }
        }
    }
    
    // MARK: life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupCalendarView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backButtonArrow()
    }
    
    // MARK: SETUP
    private func setup() {
        self.title = "Timesheet".localized
        self.weekViewStackView.addBorder(edges: [.top, .bottom], color: UIColor.grayCity(), thickness: 1)
        
        let btnCreateNew = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.createTimesheet))
        self.navigationItem.rightBarButtonItem = btnCreateNew
        
        // Table
        self.tableTimesheets.hideEmtpyCells()

        // refresh controller
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.reload), for: .valueChanged)
        self.tableTimesheets.refreshControl = refreshControl
        self.tableTimesheets.registerNib(TimesheetTableViewCell.self)
    }
    
    // MARK: setup UI calendar
    private func setupCalendarView() {
        self.calendarView.minimumLineSpacing = 0
        self.calendarView.minimumInteritemSpacing = 0
        self.calendarView.showsHorizontalScrollIndicator = false
        self.calendarView.scrollingMode = .stopAtEachCalendarFrame
        self.calendarView.scrollDirection = .horizontal
        self.calendarView.allowsMultipleSelection = false
        self.calendarView.scrollToDate(Date(), animateScroll: false)
    }
    
    // MARK:- WEB SERVICE
    private func getTimesheets() {
        let visibleDates = self.calendarView.visibleDates()
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
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: PULL TO REFRESH ACTION
    @objc private func reload() {
        self.getTimesheets()
        self.tableTimesheets.refreshControl?.endRefreshing()
    }
    
    // MARK: NEW TIMESHEET
    @objc private func createTimesheet() {
        
        let vcNewTimesheet = Storyboard.getInstanceOf(TimesheetDetailController.self)
        vcNewTimesheet.mode = .new
        
        let navBar = BTSNavigationController(rootViewController: vcNewTimesheet)
        navBar.modalPresentationStyle = .fullScreen
        
        self.present(navBar, animated: true, completion: nil)
    }
    
    // MARK: ACTIONS BUTTONS
    @IBAction private func nextWeek(_ sender: Any) {
        self.calendarView.deselectAllDates()
        self.calendarView.scrollToSegment(.next)
    }
    
    @IBAction private func previousWeek(_ sender: Any) {
        self.calendarView.deselectAllDates()
        self.calendarView.scrollToSegment(.previous)
    }
    
    @IBAction func showToday(_ sender: Any) {
        self.calendarView.scrollToDate(Date(), animateScroll: true)
        self.calendarView.deselectAllDates()
        self.calendarView.selectDates([Date()])
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let dateSelectedString = dateFormatter.string(from: Date())
        self.headerCalendarMonthLabel.setTitle(dateSelectedString, for: .normal)
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
            calendarCell.statusDotView.backgroundColor = .lightGray
        case .incomplete:
            calendarCell.statusDotView.backgroundColor = .yellow
        case .complete:
            calendarCell.statusDotView.backgroundColor = .green
        case .extraHours:
            calendarCell.statusDotView.backgroundColor = .orange
        }
        return calendarCell
    }
    
    func checkTimesheetDayAndFullColor(_ calendarCell: CalendarCell, _ cellState: CellState) -> StatusTimesheet {
        var status: StatusTimesheet = .empty
        for registerTimesheet in weekTimesheets ?? [] {
            if let timesheetDate = registerTimesheet.date {
                
                let timesheetIsoDate = timesheetDate.toISODate()?.date
                
                var workedHours = 0
                
                if cellState.date.day == timesheetIsoDate?.day {
                    for descriptionTimesheet in registerTimesheet.descriptions ?? [] {
                        if let dedicatedHours = descriptionTimesheet.dedicatedHours {
                            workedHours += dedicatedHours
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
                    break
                }
            }
        }
        return status
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let calendarCell = cell as? CalendarCell else { return }
        calendarCell.selectedView.isHidden = false
        self.selectedDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let dateSelectedString = dateFormatter.string(from: date)
        self.headerCalendarMonthLabel.setTitle(dateSelectedString, for: .normal)
    }
    
    // a base del dia seleccionado recorrer timesheet y guardar tal arreglo en una variable.
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let calendarCell = cell as? CalendarCell else { return }
        calendarCell.selectedView.isHidden = true
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        if visibleDates.monthDates.contains(where: { $0.date.date == Date().date }){
            self.calendarView.selectDates([ Date() ])
        } else {
            self.calendarView.selectDates([ visibleDates.monthDates[0].date ])
        }
        self.getTimesheets()
    }
}

// MARK: Table Delegate
extension TimesheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dayTimesheets?.descriptions?.count ?? 0 == 0 {
            self.tableTimesheets.displayBackgroundMessage(message: "No timesheets registered".localized)
            return 0
        } else {
            self.tableTimesheets.dismissBackgroundMessage()
            return dayTimesheets?.descriptions?.count ?? 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: TimesheetTableViewCell.self)
        guard let descriptionsTS = self.dayTimesheets?.descriptions else {
            return UITableViewCell()
        }
        cell.setTimesheetValues(timesheetDescription: descriptionsTS[indexPath.row])
        
        cell.onTapNote = { [weak self] in
            // FIXME: Create a controller with popup style instead of use alert native class (uncustomizable)
            let alertVC = self?.alertService.alert(descriptionsTS[indexPath.row].note)
            self?.present(alertVC!, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let actionEdit: UITableViewRowAction = UITableViewRowAction(style: .default, title: "Edit") { (action, index) in
            print("edit")
        }
        
        let actionDelete: UITableViewRowAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            let alertDelete = UIAlertController(title: "Wait", message: "Are you sure you want to delete it?", preferredStyle: .alert)
            alertDelete.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                // si es el ultimo mandar a llamar el delete, si no, sera un update.
                self.dayTimesheets?.descriptions?.remove(at: indexPath.row)
                if self.dayTimesheets?.descriptions?.count == 0 {
                    self.timesheetVM.deleteUserTimesheet(String(self.dayTimesheets!.date!.prefix(10)), { [weak self] result in
                        switch result {
                        case .success(let deleted):
                            if deleted {
                                self?.getTimesheets()
                            } else {
                                MessageManager.shared.showBar(title: "Connot delete", subtitle: "Timesheet connot deleted try again".localized, type: .warning, containsIcon: true, fromBottom: false)
                            }
                        case .failure(let error):
                            print(error)
                            print(error.localizedDescription)
                        }
                    })
                } else {
                    self.timesheetVM.updateUserTimesheet(self.dayTimesheets) { resultPost in
                        switch resultPost {
                        default:
                            print("venga")
                        }
                    }
                }
            }))
            self.present(alertDelete, animated: true, completion: nil)
        }
        
        actionEdit.backgroundColor = .blueBelize()
        actionDelete.backgroundColor = .redAlizarin()
        return [actionDelete, actionEdit]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vcNewTimesheet = Storyboard.getInstanceOf(TimesheetDetailController.self)
        vcNewTimesheet.dateTitle = dayTimesheets?.date
        vcNewTimesheet.setupVales(dayTimesheets?.descriptions?[indexPath.row])
                
        self.navigationController?.pushViewController(vcNewTimesheet, animated: true)
    }
}
