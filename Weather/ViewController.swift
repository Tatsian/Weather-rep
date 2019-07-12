import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var daysTableView: UITableView!
    @IBOutlet weak var hoursCollectionView: UICollectionView!
    @IBOutlet weak var currentCity: UILabel!
    
    let arrayOfDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sut", "Sun"]
    
    var locationManager = CLLocationManager()
    var urlString = "https://www.metaweather.com/api/location/"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLocation()
    }
    
    func updateLocation() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self //как только меняется место положение срабатывает метод делегата и получаем новую точку
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation() // слежение за местом положения
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let lattLong = "\(locValue.latitude),\(locValue.longitude)"
        let urlWithWoeid = self.urlString + "search/?lattlong=" + lattLong
        print("url for woeid finding1: \(urlWithWoeid)")
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        guard let location: CLLocation = manager.location else { return }
        self.fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
            self.currentCity.text = city
        }
        downloadDataWoeid(url: urlWithWoeid)
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    func downloadDataWoeid(url: String) {
        print("url for woeid finding2: \(url)")
        guard let url = URL(string: url) else { return}
        let dataTask = URLSession.shared.dataTask(with: url) {
            (data, responce, error) in guard let dataResponceWoeid = data else { return }
            self.parseDataWoeid(data: dataResponceWoeid)
        }
        dataTask.resume()
    }
    
    func parseDataWoeid(data: Data) {
        do {
            let woeidInfo = try JSONDecoder().decode([FindingWoeid].self, from: data)
            print("Array of data with woeid: \(woeidInfo)")
            for count in 0..<woeidInfo.count {
                let city = woeidInfo[count].title
                if city == currentCity.text {
                    let   woeidValue = woeidInfo[count].woeid
                    print("WOEID1: \(woeidValue)")
                    downloadData(woeid: woeidValue)
                }
            }
        } catch let error {
            print("there is an error: \(error)")
        }
        
    }
    
    func downloadData(woeid: Int) {
        let urlWithWoeid = urlString + String(woeid)
        print("url with woeid a: \(urlWithWoeid)")
        guard let url = URL(string: urlWithWoeid) else { return}
        let dataTask = URLSession.shared.dataTask(with: url) {
            (data, responce, error) in guard let dataResponce = data else { return }
            self.parseData(data: dataResponce)
        }
        dataTask.resume()
    }
    
    func parseData(data: Data) {
        do {
            let weatherInfo = try JSONDecoder().decode(WeatherModel.self, from: data)
            print("Array with weather data:\(weatherInfo)")
            let todayMax = weatherInfo.consolidatedWeather[0].maxTemp
            let dateOfADay = weatherInfo.consolidatedWeather[0].applicableDate
            print("current date: \(dateOfADay)")
            print("max temp: \(todayMax)")
            
        } catch let error {
            print("there is an error: \(error)")
        }
    }
    
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

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = hoursCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionIdentifier", for: indexPath) as? HoursCollectionViewCell else { return UICollectionViewCell()}
        cell.hoursCell.text = String(indexPath.row)
        return cell
    }
    
    
}
