//
//  isHappyTableViewCell.swift
//  BTSPocket
//
//  Created by bts on 14/07/21.
//

import UIKit

class isHappyViewCell: UITableViewCell {

    //MARK: OUTLETS AND VARIABLE
    @IBOutlet weak var imageViewBad: UIButton!
    @IBOutlet weak var imageViewGood: UIButton!
    
    var isHappy = true
    
    var onChangeSelection: ((_ content: Bool) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: BUTTON ACTIONS
    @IBAction func happySelection(_ sender: Any) {
        self.isHappy = true
        self.changeSelection(self.isHappy)
    }
    
    @IBAction func unappySelection(_ sender: Any) {
        self.isHappy = false
        self.changeSelection(self.isHappy)
    }
    
    // MARK: SETUP
    /// show just one image in detail mode
    func setup(_ setupIsHappy: Bool) {
        self.isHappy = setupIsHappy
        self.changeSelection(self.isHappy)
    }
    
    /// Change the alpha in the images as a selection
    func changeSelection(_ isHappySelection: Bool) {
        if isHappySelection {
            self.imageViewBad.alpha = 0.20
            self.imageViewGood.alpha = 1
        } else {
            self.imageViewBad.alpha = 1
            self.imageViewGood.alpha = 0.20
        }
        self.onChangeSelection?(isHappySelection)
    }
    
}
