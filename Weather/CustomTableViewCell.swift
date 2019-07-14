import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nextDate: UILabel!
    @IBOutlet weak var tableImage: UIImageView!
    @IBOutlet weak var minTempOfNextDate: UILabel!
    @IBOutlet weak var maxTempOfNextDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nextDate.text = ""
    }
    
    func setUpCell(info: WeatherForDay) {
        nextDate.text = info.applicableDate
        minTempOfNextDate.text = String(Int(info.minTemp)) + "º"
        maxTempOfNextDate.text = String(Int(info.maxTemp)) + "º"
    }
}


