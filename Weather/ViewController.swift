import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var daysTableView: UITableView!
    @IBOutlet weak var hoursCollectionView: UICollectionView!
    @IBOutlet weak var currentCity: UILabel!
    
    let arrayOfDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sut", "Sun"]

    var locationManager = CLLocationManager()
    var urlString = "https://www.metaweather.com/api/location/44418/"

    override func viewDidLoad() {
        super.viewDidLoad()
        updateLocation()
        downloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        guard let location: CLLocation = manager.location else { return }
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
            self.currentCity.text = city
        }
    }
    
    func updateLocation() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self //как только меняется место положение срабатывает метод делегата и получаем новую точку
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation() // слежение за местом положения
        }
    }
    
    func findWoeidLocatin() {
        
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    func downloadData() {
        guard let url = URL(string: urlString) else { return}
        let dataTask = URLSession.shared.dataTask(with: url) {
            (data, responce, error) in guard let dataResponce = data else { return }
            self.parseData(data: dataResponce)
        }
        dataTask.resume()
    }
    
    func parseData(data: Data) {
        do {
            let weatherInfo = try JSONDecoder().decode(WeatherModel.self, from: data)
            print(weatherInfo)
            let todayMax = weatherInfo.consolidatedWeather[0].maxTemp
            let dateOfADay = weatherInfo.consolidatedWeather[0].applicableDate
            print(dateOfADay)
            print(todayMax)
            
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
