//
//  NotesViewController.swift
//  BTSPocket
//
//

import UIKit

class NotesViewController: UIViewController {
    // MARK: OUTLETS & VARIABLES
    @IBOutlet private var viewBox: UIView!
    @IBOutlet private var btnClose: UIButton!
    @IBOutlet private var lblMessage: UITextView!
    @IBOutlet private var lblTitle: UILabel!
    
    var message: String?
    
    // MARK: LIFE CYCLE
   override func viewDidLoad() {
       super.viewDidLoad()
       self.loadConfig()
   }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewBox.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.viewBox.transform = .identity
        })
    }
    
    // MARK: CONFIG
    private func loadConfig() {
        // Titles
        self.lblTitle.text = "Comments".localized
        self.lblMessage.text = self.message

        // UI
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.btnClose.round()
        self.btnClose.backgroundColor = .closeNote()
        self.viewBox.cornerRadius(15)
    }
    
    // MARK: CLOSE
    @IBAction private func close() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: DEINIT
    deinit {
        print("Deinit: NotesViewController")
    }
}
