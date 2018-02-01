
import Foundation

class WeatherDataModel {
    
    static var main = WeatherDataModel()
    
    //날씨 데이터
    var address: String = ""
    var temperature: Int = 0
    var condition: Int = 0
    var forecastCount: Int = 0
    var city: String = ""
    var weatherIconName: String = ""
    var weatherDate: [Date] = []
    var weatherLocationX: String = ""
    var weatherLocationY: String = ""
    var weatherData: [WeatherModel] = []
    
    //미세먼지 데이터
    var dustData: [DustModel] = []
    
    
//    없어도 되는데 없애진 말고 일단 두고 보자
//    var address: String = ""
//    var dataTime: String = ""
//    var mangName: String = ""
//    var so2Value: String = ""
//    var coValue: String = ""
//    var o3Value: String = ""
//    var no2Value: String = ""
//    var pm10Value: String = ""
//    var pm10Value24: String = ""
//    var pm25Value: String = ""
//    var pm25Value24: String = ""
//    var khaiValue: String = ""
//    var khaiGrade: String = ""
//    var so2Grade: String = ""
//    var coGrade: String = ""
//    var o3Grade: String = ""
//    var no2Grade: String = ""
//    var pm10Grade: String = ""
//    var pm25Grade: String = ""
//    var pm10Grade1h: String = ""
//    var pm25Grade1h: String = ""
    
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
        case 800 :
            return "Sunny"
        case 801..<900 :
            return "Cloudy"
        case 900...903, 905...1000  :
            return "Windy"
        case 904 :
            return "Sunny"
        default:
            return "dunno"
        }
    }
    
}
