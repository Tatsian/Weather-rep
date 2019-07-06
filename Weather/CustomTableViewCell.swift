import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myLabel.text = ""
    }
    
    func setUpCell(string: String) {
        myLabel.text = string
    }
    
}
