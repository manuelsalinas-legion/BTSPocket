//
//  ProjectTableCell.swift
//  BTSPocket
//
//

import UIKit

class ProjectTableCell: UITableViewCell {
    // MARK: OUTLETS & VARIABLES
    @IBOutlet private var lblTitle: UILabel!
    @IBOutlet private var lblProjectName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    // MARK: INFO
    func loadInfo(_ projectName: String?) {
        self.lblProjectName.text = projectName
    }
    
}
