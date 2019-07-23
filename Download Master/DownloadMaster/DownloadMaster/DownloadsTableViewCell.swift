import UIKit

class DownloadsTableViewCell: UITableViewCell {

    @IBOutlet weak var dowLabel: UILabel!
    @IBOutlet weak var dowImage: UIImageView!
    @IBOutlet weak var dowProgress: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dowLabel.text = ""
    }
    
    func setUpCell(info: String) {
        dowLabel.text = info
    
    }

}
