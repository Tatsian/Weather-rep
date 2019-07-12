import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var daysTableView: UITableView!
    @IBOutlet weak var hoursCollectionView: UICollectionView!
    @IBOutlet weak var currentCity: UILabel!
    @IBOutlet weak var tempNow: UILabel!
    @IBOutlet weak var windSpeedNow: UILabel!
    @IBOutlet weak var weatherStateNow: UILabel!
    
    var locationManager = CLLocationManager()
    var urlString = "https://www.metaweather.com/api/location/"
    var weatherData: WeatherModel? //создала переменную, чтобы использовать распаршенные данные из любого места в коде. опшинал, тк не знаю как создать пустое значение
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLocation()
    }
    
    func updateLocation() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self //как только меняется место положение срабатывает метод делегата и получаем новую точку
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//            locationManager.startUpdatingLocation() // слежение за местом положения
            locationManager.startMonitoringSignificantLocationChanges()
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
             DispatchQueue.main.async {
            self.parseDataWoeid(data: dataResponceWoeid)
            }
        }
        dataTask.resume()
    }
    
    func parseDataWoeid(data: Data) {
        do {
            let woeidInfo = try JSONDecoder().decode([FindingWoeid].self, from: data)
            print("Array of data with woeid: \(woeidInfo)")
            if let nearest = woeidInfo.first {
                downloadData(woeid: nearest.woeid)
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
            weatherData = weatherInfo //присвоила глобальной переменной (из которой буду брать значения для табл) значение полученных данных
            print("Array with weather data:\(weatherInfo)")
            let todayMax = weatherInfo.consolidatedWeather[0].maxTemp
            print("max temp: \(todayMax)")
             DispatchQueue.main.async {
                self.daysTableView.reloadData()
            self.updateWeatherToday(data: weatherInfo)
            }
        } catch let error {
            print("there is an error: \(error)")
        }
    }
    
    func updateWeatherToday(data: WeatherModel) {
        tempNow.text = String(Int(data.consolidatedWeather[0].theTemp)) + "º"
        windSpeedNow.text = String(Int(data.consolidatedWeather[0].windSpeed)) + " km/h"
        weatherStateNow.text = String(data.consolidatedWeather[0].weatherStateName)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let weatherData = weatherData else {return 0}
        return weatherData.consolidatedWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell Identifier", for: indexPath) as? CustomTableViewCell else { return UITableViewCell()}
        guard let weatherData = weatherData else { return cell}
        let info = weatherData.consolidatedWeather[indexPath.row]
        cell.setUpCell(info: info)
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
