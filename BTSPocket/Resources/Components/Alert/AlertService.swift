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
    func alert(_ bodyNote: String?) -> NoteAlertViewController {
        let storyboard = UIStoryboard(name: "NoteAlertStoryboard", bundle: .main)
        let noteAlertVC = storyboard.instantiateViewController(identifier: "NoteAlertVC") as! NoteAlertViewController
        noteAlertVC.alertMessage = bodyNote
        return noteAlertVC
    }
}
