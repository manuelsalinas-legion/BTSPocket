//
//

import UIKit

class PickerCell: UITableViewCell
{
    //MARK: - PROPERTIES AND OULETS
    @IBOutlet weak private var pickerView: UIPickerView!
    
    var onSelected:((_ index: Int) -> ())?
    var options = [String]() {
        didSet {
            self.pickerView.reloadAllComponents()
        }
    }
    
    //MARK: - LIFE CYCLE
    override func awakeFromNib()
    {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}

extension PickerCell: UIPickerViewDataSource, UIPickerViewDelegate
{
    // MARK: DATASOURCE UIPICKERVIEW
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.options.count
    }
    
    // MARK: DELEGATE UIPICKERVIEW
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.options[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.onSelected?(row)
    }
}
