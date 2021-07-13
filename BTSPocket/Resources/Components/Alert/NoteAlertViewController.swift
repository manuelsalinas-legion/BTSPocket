//
//  NoteAlertViewController.swift
//  BTSPocket
//
//  Created by bts on 08/07/21.
//

import UIKit

class NoteAlertViewController: UIViewController {

    // MARK: Outlets and Variables
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    var alertMessage: String? = String()
    
    // MARK: Life cicles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelMessage?.text = "Comment".localized
        setUpView()
    }
    
    // MARK: Close action
    @IBAction func buttonCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // setup view
    func setUpView() {
        self.labelMessage?.text = alertMessage
    }
}
