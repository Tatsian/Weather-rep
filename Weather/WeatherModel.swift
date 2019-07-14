import Foundation

struct WeatherModel: Codable {
    let consolidatedWeather: [WeatherForDay]
    let title: String
    private enum CodingKeys: String, CodingKey {
        case consolidatedWeather = "consolidated_weather"
        case title
    }
}

struct WeatherForDay: Codable {
    let applicableDate: String
    let minTemp: Double
    let maxTemp: Double
    let windSpeed: Double
    let weatherStateName: String
    let theTemp: Double
    let weatherStateAbbr: String
        private enum CodingKeys: String, CodingKey {
            case applicableDate = "applicable_date"
            case minTemp = "min_temp"
            case maxTemp = "max_temp"
            case windSpeed = "wind_speed"
            case weatherStateName = "weather_state_name"
            case theTemp = "the_temp"
            case weatherStateAbbr = "weather_state_abbr"
        }
}

struct FindingWoeid: Codable {
    let title: String
    let woeid: Int

}
