import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var daysTableView: UITableView!
    
    let arrayOfDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sut", "Sun", "Tue", "Wed", "Thu", "Fri", "Sut", "Sun"]
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell Identifier", for: indexPath) as? CustomTableViewCell else { return UITableViewCell()}
        cell.setUpCell(string: arrayOfDays[indexPath.row])
        return cell
    }
    
}

