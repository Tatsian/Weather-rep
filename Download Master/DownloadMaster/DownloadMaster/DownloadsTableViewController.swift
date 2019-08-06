import UIKit

//для сохранения данных в таблицу
let defaults = UserDefaults(suiteName: "com.Saving.Data")

class DownloadsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var downloadsTable: UITableView!
    
    var arrayData = [String]()
    var searchArray = [String]()
    var searchController = UISearchController()
    var searchingWasActivated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search file..."
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableHeaderView = searchController.searchBar
        tableView.reloadData()
        navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        storeData()
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        alertWithTF()
    }
    
    func loadAction(url: String) {
        let data = NSData(contentsOf: NSURL(string: url)! as URL)
        //как сохранить данные разных форматов??
        
        
    }
    
    func alertWithTF() {
        let alert = UIAlertController(title: "Download URL", message: "Please input URL of the file", preferredStyle: UIAlertController.Style.alert)
        let save = UIAlertAction(title: "Load and Save", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            guard let text = textField.text, !text.isEmpty else {
                print("TF is Empty...")
                return
            }
            self.downloadData(urlForFile: text)
            self.saveCotent()
            print("TF: \(text)")
            self.arrayData.append(text)
            self.tableView.reloadData()
            self.storeData()
        }
        
        
        alert.addTextField { (textField) in
            textField.placeholder = "https://example.com"
            textField.textColor = .green
        }
        
        alert.addAction(save)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in }
        alert.addAction(cancel)
        self.present(alert, animated:true, completion: nil)
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchingWasActivated {
            return searchArray.count
        } else {
            return arrayData.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "downloadsIdentirier", for: indexPath) as? DownloadsTableViewCell else { return UITableViewCell()}
        if searchingWasActivated  {
            let info = searchArray[indexPath.row]
            cell.setUpCell(info: info)
        } else {
            let info = arrayData[indexPath.row]
            cell.setUpCell(info: info)
        }
        
        return cell
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        searchingWasActivated = true
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            searchArray = arrayData.filter { team in
                return team.lowercased().contains(searchText.lowercased())
            }
        } else {
            searchArray = arrayData
        }
        self.tableView.reloadData()
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            arrayData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            storeData()
        }
    }
    //save data/get to table
    func storeData() {
        defaults?.set(arrayData, forKey: "saveData")
        defaults?.synchronize()
    }
    
    func getData() {
        let data = defaults?.value(forKey: "saveData")
        guard let tableData = data else {return}
        arrayData = tableData as! [String]
    }
    
    func downloadData(urlForFile: String) {
        guard let url = URL(string: urlForFile) else { return }
        let downloadTask = URLSession.shared.downloadTask(with: url) {
            urlOrNil, responseOrNil, errorOrNil in
            
            guard let fileURL = urlOrNil else { return }
            do {
                let documentsURL = try
                    FileManager.default.url(for: .documentDirectory,
                                            in: .userDomainMask,
                                            appropriateFor: nil,
                                            create: false)
                let savedURL = documentsURL.appendingPathComponent(
                    fileURL.lastPathComponent)
                try FileManager.default.moveItem(at: fileURL, to: savedURL)
            } catch {
                print ("file error: \(error)")
            }
        }
        print("save: \(urlForFile)")
        downloadTask.resume()
    }
    
    func saveCotent() {
        let pathForSave = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        print("Save content: \(pathForSave)")
    }
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension UITableViewController:  URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
    }
}
