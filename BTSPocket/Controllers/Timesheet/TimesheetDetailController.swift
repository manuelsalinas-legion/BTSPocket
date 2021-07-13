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

class TimesheetDetailController: UIViewController {
    // MARK: OUTLWTS & PROPERTIES
    @IBOutlet weak var labelHours: UILabel!
    @IBOutlet weak var labelTask: UITextView!
    @IBOutlet weak var labelComment: UITextView!
    
    var mode: TimesheetDetailMode = .detail
    var dateTitle: String?
    
    
    // MARK: LYCE CYLE
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
        
        switch self.mode {
        case .new, .editable:
            
            let btnClose = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.close))
            self.navigationItem.leftBarButtonItem = btnClose
            self.title = self.mode == .new ? "New Timesheet".localized : "date title goes here"
            
        case .detail:
            self.title = self.dateTitle
        }
    }
    
    // MARK: ACTIONS
    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupVales(_ description: TimesheetDescription?) {
        self.labelHours?.text = String(description?.dedicatedHours ?? 8)
        self.labelTask?.text = description?.task
        self.labelComment?.text = description?.note
    }
}
