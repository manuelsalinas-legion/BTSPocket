//
//  TimesheetDetailController.swift
//  BTSPocket
//
//  Created by Manuel Salinas on 7/6/21.
//

import UIKit

enum TimesheetDetailMode {
    case new, detail, editable
}

private enum DetailTimesheetSection: Int {
    case hours, task, comment, isHappy
}

class TimesheetDetailController: UIViewController {
    // MARK: OUTLETS & PROPERTIES
    @IBOutlet weak var tableViewTimesheet: UITableView!
    
    var mode: TimesheetDetailMode = .detail
    var dateTitle: String?
    var timesheetDetails: TimesheetDescription?
    
    
    // MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backButtonArrow()
    }
    
    // MARK: SETUP
    private func setup() {
        // register table cells
        self.tableViewTimesheet.registerNib(HoursTableViewCell.self)
        self.tableViewTimesheet.registerNib(DescriptionTableViewCell.self)
        
        switch self.mode {
        case .new, .editable:
            
            let btnClose = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.close))
            self.navigationItem.leftBarButtonItem = btnClose
            self.title = self.mode == .new ? "New Timesheet".localized : "date title goes here"
            
        case .detail:
            self.title = self.dateTitle
            let btnClose = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.close))
            self.navigationItem.leftBarButtonItem = btnClose
            
            
        }
    }
    
    // MARK: ACTIONS
    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TimesheetDetailController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case DetailTimesheetSection.hours.rawValue:
            let hoursCell: HoursTableViewCell = tableView.dequeueReusableCell(withClass: HoursTableViewCell.self)
            return hoursCell
        case DetailTimesheetSection.task.rawValue:
            let descriptionCell: DescriptionTableViewCell = tableView.dequeueReusableCell(withClass: DescriptionTableViewCell.self)
            return descriptionCell
        case DetailTimesheetSection.comment.rawValue:
            let descriptionCell: DescriptionTableViewCell = tableView.dequeueReusableCell(withClass: DescriptionTableViewCell.self)
            return descriptionCell
        case DetailTimesheetSection.isHappy.rawValue:
            //falta la celda customizada de
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case DetailTimesheetSection.task.rawValue:
            return 20
        case DetailTimesheetSection.comment.rawValue:
            return 20
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case DetailTimesheetSection.task.rawValue:
            return "Describe your task"
        case DetailTimesheetSection.comment.rawValue:
            return "Any comment?"
        default:
            return ""
        }
    }
}
