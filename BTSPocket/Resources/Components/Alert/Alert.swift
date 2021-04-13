//
//  Alert.swift
//  BTSPocket
//
//  Created by bts on 01/04/21.
//

import Foundation
import UIKit

/// Show an OK alert just with title and message
func showAlert(view:UIViewController, title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    view.present(alert, animated: true, completion: nil)
}
