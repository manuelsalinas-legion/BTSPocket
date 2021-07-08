//
//  NoteAlertViewController.swift
//  BTSPocket
//
//  Created by bts on 08/07/21.
//

import UIKit

class NoteAlertViewController: UIAlertController {

    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewNote: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.viewNote.cornerRadius()
    }
    @IBAction func buttonClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
