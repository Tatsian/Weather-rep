import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nextDate: UILabel!
    @IBOutlet weak var tableImage: UIImageView!
    @IBOutlet weak var minTempOfNextDate: UILabel!
    @IBOutlet weak var maxTempOfNextDate: UILabel!
    
        let stateImageDictionary = ["c" : #imageLiteral(resourceName: "c") , "h" : #imageLiteral(resourceName: "h"), "hc" : #imageLiteral(resourceName: "hc"), "hr" : #imageLiteral(resourceName: "hr"), "lc" : #imageLiteral(resourceName: "lc"), "lr" : #imageLiteral(resourceName: "lr"), "s" : #imageLiteral(resourceName: "s"), "sl" : #imageLiteral(resourceName: "sl"), "sn" : #imageLiteral(resourceName: "sn"), "t" : #imageLiteral(resourceName: "t")]
    
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
        tableImage.image = stateImageDictionary[info.weatherStateAbbr]
    }
}


