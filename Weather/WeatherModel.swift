import Foundation

struct WeatherModel: Codable {
    let consolidatedWeather: [WeatherForDay]
    private enum CodingKeys: String, CodingKey {
        case consolidatedWeather = "consolidated_weather"
    }
}

struct WeatherForDay: Codable {
    let applicableDate: String
    let minTemp: Double
    let maxTemp: Double
    let windSpeed: Double
    let weatherStateName: String
    let theTemp: Double
        private enum CodingKeys: String, CodingKey {
            case applicableDate = "applicable_date"
            case minTemp = "min_temp"
            case maxTemp = "max_temp"
            case windSpeed = "wind_speed"
            case weatherStateName = "weather_state_name"
            case theTemp = "the_temp"
        }
}

struct FindingWoeid: Codable {
    let title: String
    let woeid: Int

}
