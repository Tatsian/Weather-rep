import Foundation

struct WeatherModel: Codable {
    let consolidatedWeather: [WeatherForDay]
    let windSpeed: Double
    let weatherStateName: String
    let theTemp: Double
    private enum CodingKeys: String, CodingKey {
        case consolidatedWeather = "consolidated_weather"
        case windSpeed = "wind_speed"
        case weatherStateName = "weather_state_name"
        case theTemp = "the_temp"
    }
}

struct WeatherForDay: Codable {
    let applicableDate: String
    let minTemp: Double
    let maxTemp: Double
    private enum CodingKeys: String, CodingKey {
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case applicableDate = "applicable_date"
    }
    
}
//
//struct FindingWoeid: Codable {
//    let title: String
//    let woeid: Int
//    private enum CodingKeys: String, CodingKey {
//        case title
//        case woeid
//    }
//}
