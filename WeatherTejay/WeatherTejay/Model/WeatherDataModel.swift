
import Foundation

class WeatherDataModel {
    
    static var main = WeatherDataModel()
    
    var temperature: Int = 0
    var condition: Int = 0
    var forecastCount: Int = 0
    var city: String = ""
    var weatherIconName: String = ""
    
    func updateWeatherIcon(condition: Int) -> String {
        switch (condition) {
        case 0..<300 :
            return "Thunder"
        case 300..<500 :
            return "Drizzle"
        case 500..<600 :
            return "Rainy"
        case 600..<700 :
            return "Snowing"
        case 700..<800 :
            return "Windy"
        case 800..<900 :
            return "Cloudy"
        default:
            return "dunno"
        }
    }
    
}
