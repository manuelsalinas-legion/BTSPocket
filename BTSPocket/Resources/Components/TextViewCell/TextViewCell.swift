//
//

import UIKit

class TextViewCell: UITableViewCell
{
    //MARK: PROPERTIES & OUTLETS
    @IBOutlet weak var tvText: UITextView!
    
    let kPlaceholderColor = UIColor.grayCity()
    let kLimitOfCharacters: Int = 300
    var allowMultiline = true
    var placeHolder = String() {
        didSet {
        
            if self.tvText.text.trim().isEmpty == true
            {
                self.tvText.textColor = kPlaceholderColor
                self.tvText.text = self.placeHolder.isEmpty == true ? "Comments".localized : self.placeHolder
            }
            else
            {
                self.tvText.textColor = .darkGray
                self.tvText.text = tvText.text
            }
        }
    }
    var onTextChange:((_ content: String) -> ())?
    var onTextDidBegin:(()->())?
    var onTextDidEnd:(()->())?
    
    //MARK: LIFE CYCLE
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.tvText.delegate = self        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    func loadCell(_ text:String)
    {
        if text.trim().isEmpty == true
        {
            self.tvText.textColor = kPlaceholderColor
            self.tvText.text = self.placeHolder.isEmpty == true ? "Comments".localized : self.placeHolder
        }
        else
        {
            self.tvText.textColor = .darkGray
            self.tvText.text = text
        }
    }
}

//MARK: DELEGATE
extension TextViewCell: UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        self.onTextDidBegin?()
       
        if textView.textColor == kPlaceholderColor
        {
           textView.text = String()
           textView.textColor = .darkGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        
        if textView.text.isEmpty == true
        {
            textView.textColor = kPlaceholderColor
            textView.text = self.placeHolder.isEmpty == true ? "Comments".localized : self.placeHolder
        }
        self.onTextDidEnd?()
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        self.onTextChange?(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        //Avoiding break lines
        if self.allowMultiline == false
        {
            guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
                
                textView.resignFirstResponder()
                return false
            }
        }
        
        //Avoiding over limit
        return textView.text.count + text.count - range.length <= self.kLimitOfCharacters
        
        return true
    }
}
