//
//  Alert.swift
//  BTSPocket
//
//  Created by bts on 01/04/21.
//

import Foundation
import UIKit

///Return an alert view controller
class AlertService {
    func alert() -> NoteAlertViewController {
        let noteAlertVC = NoteAlertViewController()
        noteAlertVC.labelMessage?.text = "asdasd"
        return noteAlertVC
    }
}
