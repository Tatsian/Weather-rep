import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nextDate: UILabel!
    
    @IBOutlet weak var minTempOfNextDate: UILabel!
    @IBOutlet weak var maxTempOfNextDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nextDate.text = ""
    }
    
    func setUpCell(info: WeatherModel) {
        DispatchQueue.main.sync { //тк обновления происх в главном экране
        for i in 1...5 {
            nextDate.text = info.consolidatedWeather[i].applicableDate
            minTempOfNextDate.text = String(info.consolidatedWeather[i].minTemp)
            maxTempOfNextDate.text = String(info.consolidatedWeather[i].maxTemp)
            } // данные для таблицы 
        }
    }
    
//    func setUpCell(string: String) {
//        nextDate.text = string
//    }
}


