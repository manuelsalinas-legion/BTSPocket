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

typealias TimesheetDetail = (timesheets: Timesheet, timesheetId: Int)

class TimesheetDetailController: UIViewController {
    // MARK: OUTLETS & PROPERTIES
    @IBOutlet weak var tableViewTimesheet: UITableView!
    
    private var projectPickerCollapsed = true {
        didSet {
            self.tableViewTimesheet.reloadRows(at: [IndexPath(row: 1, section: DetailTimesheetSection.project.rawValue)], with: .fade)
        }
    }
    
    var mode: TimesheetDetailMode = .detail
    var dateTitle: String?
    var info: TimesheetDetail?
    //cuando se seleccione un timesheet
    //popular la deswcripcion y el id
    //para poderlo guardar.
    //TimesheetDate(timesheets: TimesheetDescription, timesheetId: Int)
    
    // obtiene todos y el id del que se va a mostrar.
    // teniendo el respaldo en el original.
    // si la respuesta que es correcta. substituir el timesheet detail que esta dentro de la tupla
    // y retornarlo para que actualice la data.
    
    var timesheetDetails: TimesheetDescription?
    var dayTimesheets: Timesheet?
    
    private var newTimesheet: TimesheetDescriptionsObject?
    
    
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
        case .new, .editable:
            
            let btnClose = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.close))
            // Agregar propiedad de btnSave opcional para poderla maneajar en toda la clase.
            let btnSave = UIBarButtonItem(title: "Save", style: .plain, target: self, action: nil)
            self.navigationItem.leftBarButtonItem = btnClose
            self.navigationItem.rightBarButtonItem = btnSave
            self.title = self.mode == .new ? "New Timesheet".localized : "date title goes here"
            
        case .detail:
            self.title = self.dateTitle
        }
    }
    
    // MARK: ACTIONS
    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func save() {
        
    }
}

extension TimesheetDetailController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        DetailTimesheetSection.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //checar primero si es nuevo van a ser 5
        // si en el showDetails no hay comments no mostrar los comments
        // van a ser 5 o 4
    
        // Projects has 2 rows (selected project and picker) if user has only 1 project, set it by default (no picker needed)
        return section == DetailTimesheetSection.project.rawValue && BTSApi.shared.sessionProjects.count > 1 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case DetailTimesheetSection.hours.rawValue:
            
            let hoursCell: HoursViewCell = tableView.dequeueReusableCell(withClass: HoursViewCell.self)
            if mode == .detail {
                hoursCell.detailsMode()
                hoursCell.labelHours?.text = String(self.timesheetDetails?.dedicatedHours ?? 1)
            } else {
                hoursCell.onHourChange = { [weak self] workedHours in
                    self?.newTimesheet?.dedicatedHours = workedHours
                }
            }
            return hoursCell
            
        case DetailTimesheetSection.project.rawValue:
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withClass: ProjectTableCell.self)
                if let pName = timesheetDetails?.projectName, !pName.isEmpty {
                    cell.loadInfo(pName)
                } else {
                    // Placeholder
                    cell.loadInfo("- Select Project -")
                }
                
                return cell
                
            } else {
                let projects = BTSApi.shared.sessionProjects.map({ $0.name ?? "" })
                let cell = tableView.dequeueReusableCell(withClass: PickerCell.self)
                cell.options = projects
                cell.onSelected = { index in
                    
                    let selectedProject = BTSApi.shared.sessionProjects[index]
                    print("aqui va el proyecto seleccionado -> \(selectedProject.name)")
                    self.timesheetDetails?.projectName = selectedProject.name
                    
                    tableView.reloadRows(at: [IndexPath(row: 0, section: indexPath.section)], with: .none)
                }
                
                return cell
            }
            
        case DetailTimesheetSection.task.rawValue:
            
            let taskCell: TextViewCell = tableView.dequeueReusableCell(withClass: TextViewCell.self)
            if mode == .detail {
                taskCell.tvText.text = self.timesheetDetails?.task?.capitalized
                taskCell.tvText.isEditable = false
            } else {
                taskCell.placeHolder = "Describe your task"
                taskCell.onTextChange = { [weak self] newTask in
                    self?.newTimesheet?.task = newTask
                }
            }
            return taskCell
            
        case DetailTimesheetSection.comment.rawValue:
            
            let noteCell: TextViewCell = tableView.dequeueReusableCell(withClass: TextViewCell.self)
            if mode == .detail {
                noteCell.tvText.text = self.timesheetDetails?.note?.capitalized
                noteCell.tvText.isEditable = false
            } else {
                noteCell.placeHolder = "Any comments?"
                noteCell.onTextChange = { [weak self] newNote in
                    self?.newTimesheet?.note = newNote
                }
            }
            return noteCell
            
        case DetailTimesheetSection.rate.rawValue:
            
            let isHappyCell: isHappyViewCell = tableView.dequeueReusableCell(withClass: isHappyViewCell.self)
            if mode == .detail {
                isHappyCell.setup(self.timesheetDetails?.isHappy ?? true)
            }
            else {
                isHappyCell.onChangeSelection = { [weak self] isHappy in
                    self?.newTimesheet?.isHappy = isHappy
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
