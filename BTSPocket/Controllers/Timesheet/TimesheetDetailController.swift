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

private enum DetailTimesheetSection: Int, CaseIterable {
    case hours, project, task, comment, rate
}

typealias TimesheetDetail = (timesheets: Timesheet?, timesheetId: Int)

class TimesheetDetailController: UIViewController {
    // MARK: OUTLETS & PROPERTIES
    @IBOutlet weak var tableViewTimesheet: UITableView!
    
    private var projectPickerCollapsed = true {
        didSet {
            self.tableViewTimesheet.reloadRows(at: [IndexPath(row: 1, section: DetailTimesheetSection.project.rawValue)], with: .fade)
        }
    }
    var mode: TimesheetDetailMode = .detail
    private var timesheetVM = TimesheetViewModel()
    var currentDate: String?
    var info: TimesheetDetail? {
        didSet {
            if let description = info?.timesheets?.descriptions {
                currentTimesheet = description[info?.timesheetId ?? 0]
            }
        }
    }
    var currentTimesheet: TimesheetDescription?
    
    var newTimesheet = TimesheetDescriptionsObject()
    
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
        
        self.tableViewTimesheet.estimatedRowHeight = 70  //minimum size
        self.tableViewTimesheet.rowHeight = UITableView.automaticDimension

        // register table cells
        self.tableViewTimesheet.registerNib(HoursViewCell.self)
        self.tableViewTimesheet.registerNib(TextViewCell.self)
        self.tableViewTimesheet.registerNib(isHappyViewCell.self)
        self.tableViewTimesheet.registerNib(PickerCell.self)
        self.tableViewTimesheet.registerNib(ProjectTableCell.self)
        self.tableViewTimesheet.hideEmtpyCells()
        
        switch self.mode {
        case .new:
            self.title = "New Timesheet".localized
            self.setupNewAndEditable()
        case .editable:
            self.setupNewAndEditable()
            self.title = self.info?.timesheets?.date?.toISODate()?.toFormat("MMM dd, yyyy")
            self.newTimesheet.dedicatedHours = self.currentTimesheet?.dedicatedHours
            self.newTimesheet.isHappy = self.currentTimesheet?.isHappy
            self.newTimesheet.task = self.currentTimesheet?.task
            self.newTimesheet.note = self.currentTimesheet?.note
            self.newTimesheet.projectName = self.currentTimesheet?.projectName
            self.newTimesheet.projectId = self.currentTimesheet?.projectId
            self.tableViewTimesheet.reloadData()
            
        case .detail:
            self.title = self.info?.timesheets?.date?.toISODate()?.toFormat("MMM dd, yyyy")
            let btnEdit = UIBarButtonItem(title: "Edit".localized, style: .plain, target: self, action: nil)
            self.navigationItem.rightBarButtonItem = btnEdit
        }
        self.hideSaveButton()
    }
    
    // setup
    private func setupNewAndEditable() {
        let btnClose = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.close))
        let btnSave = UIBarButtonItem(title: "Save".localized, style: .plain, target: self, action: #selector(self.save))
        self.navigationItem.leftBarButtonItem = btnClose
        self.navigationItem.rightBarButtonItem = btnSave
    }
    
    // MARK: ACTIONS
    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func save() {
        self.timesheetVM.postUserTimesheet(self.currentDate, self.info?.timesheets, newTimesheet) { result in
            switch result {
            case .success(let Timesheet):
                print(Timesheet)
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                print(error)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func hideSaveButton() {
        if mode == .editable {
            if self.newTimesheet.isReady()
                && (self.newTimesheet.task != self.currentTimesheet?.task
                        || self.newTimesheet.dedicatedHours != self.currentTimesheet?.dedicatedHours
                        || self.newTimesheet.isHappy != self.currentTimesheet?.isHappy
                        || self.newTimesheet.note != self.currentTimesheet?.note
                        || self.newTimesheet.projectId != self.currentTimesheet?.projectId) {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        } else {
            if self.newTimesheet.isReady() {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    }
}

//MARK: Table Delegate
extension TimesheetDetailController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        DetailTimesheetSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case DetailTimesheetSection.comment.rawValue:
            // The note row is hidden when it is empty
            return self.mode == .detail && currentTimesheet?.note ?? nil == nil ? 0 : 1
        case DetailTimesheetSection.project.rawValue:
            // Projects has 2 rows (selected project and picker) if user has only 1 project, set it by default (no picker needed)
            return section == DetailTimesheetSection.project.rawValue && BTSApi.shared.sessionProjects.count > 1 ? 2 : 1
        default:
            return 1
        }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case DetailTimesheetSection.hours.rawValue:
            
            let hoursCell: HoursViewCell = tableView.dequeueReusableCell(withClass: HoursViewCell.self)
            if mode == .detail {
                hoursCell.detailsMode()
                hoursCell.labelHours?.text = String(self.currentTimesheet?.dedicatedHours ?? 1)
            } else if mode == .editable{
                hoursCell.onHourChange = { [weak self] workedHours in
                    self?.newTimesheet.dedicatedHours = workedHours
                    self?.hideSaveButton()
                }
                hoursCell.labelChanged(self.newTimesheet.dedicatedHours ?? 8)
            } else {
                hoursCell.onHourChange = { [weak self] workedHours in
                    self?.newTimesheet.dedicatedHours = workedHours
                    self?.hideSaveButton()
                }
                hoursCell.setup(self.info)
            }
            return hoursCell
            
        case DetailTimesheetSection.project.rawValue:
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withClass: ProjectTableCell.self)
                if mode == .detail {
                    cell.loadInfo(self.currentTimesheet?.projectName)
                }
                if let pName = self.newTimesheet.projectName, !pName.isEmpty {
                    cell.loadInfo(pName)
                } else {
                    // Placeholder
                    cell.loadInfo("- Select Project -".localized)
                }
                
                return cell
                
            } else {
                let projects = BTSApi.shared.sessionProjects.map({ $0.name ?? "" })
                let cell = tableView.dequeueReusableCell(withClass: PickerCell.self)
                cell.options = projects
                cell.onSelected = { index in
                    
                    let selectedProject = BTSApi.shared.sessionProjects[index]
                    self.newTimesheet.projectId = selectedProject.id
                    self.newTimesheet.projectName = selectedProject.name
                    self.hideSaveButton()
                    tableView.reloadRows(at: [IndexPath(row: 0, section: indexPath.section)], with: .none)
                }
                
                return cell
            }
            
        case DetailTimesheetSection.task.rawValue:
            
            let taskCell: TextViewCell = tableView.dequeueReusableCell(withClass: TextViewCell.self)
            if mode == .detail {
                taskCell.tvText.text = self.currentTimesheet?.task?.capitalized
                taskCell.tvText.isEditable = false
            } else if mode == .new {
                taskCell.placeHolder = "Describe your task".localized
                taskCell.onTextChange = { [weak self] newTask in
                    self?.newTimesheet.task = newTask
                    self?.hideSaveButton()
                }
            } else {
                taskCell.tvText.text = self.newTimesheet.task
                taskCell.onTextChange = { [weak self] newTask in
                    self?.newTimesheet.task = newTask
                    self?.hideSaveButton()
                }
            }
            return taskCell
            
        case DetailTimesheetSection.comment.rawValue:
            
            let noteCell: TextViewCell = tableView.dequeueReusableCell(withClass: TextViewCell.self)
            if mode == .detail {
                noteCell.tvText.text = self.currentTimesheet?.note?.capitalized
                noteCell.tvText.isEditable = false
            } else if mode == .new {
                noteCell.placeHolder = "Any comments?".localized
                noteCell.onTextChange = { [weak self] newNote in
                    self?.newTimesheet.note = newNote
                    self?.hideSaveButton()
                }
            } else {
                if self.newTimesheet.note?.isEmpty == true {
                    noteCell.placeHolder = "Any comments?".localized
                } else {
                    noteCell.tvText.text = self.newTimesheet.note
                }
                noteCell.onTextChange = { [weak self] newNote in
                    self?.newTimesheet.note = newNote
                    self?.hideSaveButton()
                }
            }
            return noteCell
            
        case DetailTimesheetSection.rate.rawValue:
            
            let isHappyCell: isHappyViewCell = tableView.dequeueReusableCell(withClass: isHappyViewCell.self)
            if mode == .detail {
                isHappyCell.setup(self.currentTimesheet?.isHappy ?? true)
            }
            else if mode == .new {
                isHappyCell.onChangeSelection = { [weak self] isHappy in
                    self?.newTimesheet.isHappy = isHappy
                    self?.hideSaveButton()
                }
            } else {
                isHappyCell.setup(self.newTimesheet.isHappy ?? true)
                isHappyCell.onChangeSelection = { [weak self] isHappy in
                    self?.newTimesheet.isHappy = isHappy
                    self?.hideSaveButton()
                }
            }

            return isHappyCell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Editable?
        guard self.mode == .new || self.mode == .editable else {
            return
        }
        
        // Projects?
        if indexPath.section == DetailTimesheetSection.project.rawValue
            && indexPath.row == 0
            && BTSApi.shared.sessionProjects.count > 1 {
            self.projectPickerCollapsed = !self.projectPickerCollapsed
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == DetailTimesheetSection.project.rawValue
            && indexPath.row != 0 {
            cell.isHidden = self.projectPickerCollapsed
        }
        
        // Remove seperator inset
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        // Explictly set your cell's layout margins
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case  DetailTimesheetSection.hours.rawValue:
            return 130
        case  DetailTimesheetSection.project.rawValue:
            return indexPath.row == 0 ? tableView.rowHeight : self.projectPickerCollapsed ? CGFloat.leastNonzeroMagnitude :  120
        case  DetailTimesheetSection.rate.rawValue:
            return 88
        default:
            return tableView.rowHeight
        }
    }
}
