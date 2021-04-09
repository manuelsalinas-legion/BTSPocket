//
//

import UIKit
import AVFoundation

extension UITableView {
    func displayBackgroundMessage(_ title: String? = nil, message: String? = nil) {
        DispatchQueue.main.async {
            let lblEmptyMessage = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 63))
            lblEmptyMessage.textAlignment = .center
            lblEmptyMessage.attributedText = NSAttributedString.getAttributedSecondaryTitle(title, subtitle: message, fontSize: 16)
            lblEmptyMessage.numberOfLines = 3
            self.backgroundView = lblEmptyMessage
        }
    }
    
    func displayBackgroundView(_ view: UIView) {
        DispatchQueue.main.async {
            self.backgroundView = view
        }
    }
    
    func hideEmtpyCells() {
        self.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func dismissBackgroundMessage() {
        DispatchQueue.main.async {
            self.backgroundView = nil
        }
    }
    
    func reloadCellAtIndex(_ index: Int, section: Int = 0)
    {
        guard self.cellForRow(at: IndexPath(row: index, section: section)) != nil else {
            
            return
        }
        
        self.reloadRows(at: [(IndexPath(row: index, section: section))], with: .none)
    }
    
    /// Dequeue reusable UITableViewCell using class name
    ///
    /// - Parameter name: UITableViewCell type
    /// - Returns: UITableViewCell object with associated class name (optional value)
    public func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T?
    {
        return dequeueReusableCell(withIdentifier: String(describing: name)) as? T
    }
    
    /// Register UITableViewCell using class name
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the tableView cell.
    ///   - name: UITableViewCell type.
    public func register<T: UITableViewCell>(nib: UINib?, withCellClass name: T.Type)
    {
        register(nib, forCellReuseIdentifier: String(describing: name))
    }
    
    /// Register given `UITableViewCell` in tableView.
    /// Cell will be registered with the name of it's class as identifier.
    public func registerNib<T: UITableViewCell>(_: T.Type)
    {
        let nib = UINib(nibName: String(describing: T.self), bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: T.self))
    }
}

extension UITableViewController
{
    func displayBackgroundMessage(_ message: String, subMessage: String?)
    {
        self.tableView.displayBackgroundMessage(message, message: subMessage)
    }
    
    func dismissBackgroundMessage()
    {
        self.tableView.dismissBackgroundMessage()
    }
}

extension UITableViewCell
{ 
    func enableSelectedColor(_ color: UIColor = UIColor(red: 0.922014, green: 0.948368, blue: 0.984320, alpha: 1))
    {
        //Color for selected cell
        let selectedColor = UIView()
        selectedColor.layer.backgroundColor = color.cgColor
        self.selectedBackgroundView = selectedColor
    }
}
