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
    case hours,project, task, comment, isHappy
}

typealias TimesheetDetail = (timesheets: Timesheet, timesheetId: Int)

class TimesheetDetailController: UIViewController {
    // MARK: OUTLETS & PROPERTIES
    @IBOutlet weak var tableViewTimesheet: UITableView!
    
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
        // register table cells
        self.tableViewTimesheet.registerNib(HoursViewCell.self)
        self.tableViewTimesheet.registerNib(TextViewCell.self)
        self.tableViewTimesheet.registerNib(isHappyViewCell.self)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //checar primero si es nuevo van a ser 5
        // si en el showDetails no hay comments no mostrar los comments
        // van a ser 5 o 4
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
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
            hoursCell.selectionStyle = .none
            return hoursCell
            
        case DetailTimesheetSection.project.rawValue:
            let cell = UITableViewCell()
            cell.textLabel?.text = timesheetDetails?.projectName?.capitalized
            return cell
            
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
            
        case DetailTimesheetSection.isHappy.rawValue:
            let isHappyCell: isHappyViewCell = tableView.dequeueReusableCell(withClass: isHappyViewCell.self)
            if mode == .detail {
                isHappyCell.setup(self.timesheetDetails?.isHappy ?? true)
            }
            else {
                isHappyCell.onChangeSelection = { [weak self] isHappy in
                    self?.newTimesheet?.isHappy = isHappy
                }
            }
            isHappyCell.selectionStyle = .none
            return isHappyCell
            
        default:
            return UITableViewCell()
        }
    }
}
