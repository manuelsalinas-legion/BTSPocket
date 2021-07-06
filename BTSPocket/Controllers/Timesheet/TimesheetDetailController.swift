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
    var mode: TimesheetDetailMode = .detail
    
    
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
            self.title = "date title goes here"
        }
    }
    
    // MARK: ACTIONS
    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
