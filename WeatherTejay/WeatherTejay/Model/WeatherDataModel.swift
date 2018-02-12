
import Foundation

class WeatherDataModel {
    
    static var main = WeatherDataModel()
    
    //날씨 데이터
    var address: String = ""
    var temperature: Int = 0
    var maxTemperature: Int = 0
    var minTemperature: Int = 0
    var condition: Int = 0
    var forecastCount: Int = 0 {
        didSet{
            preforecastCount = oldValue
        }
    }
    var preforecastCount: Int = 0
    var city: String = ""
    var weatherIconName: String = ""
    var weatherDate: [Date] = []
    var weatherLocationX: String = ""
    var weatherLocationY: String = ""
    var weatherData: [WeatherModel] = []
    
    //미세먼지 데이터
    var dustData: [DustModel] = []
    var currentDustData: [String] = []
    var currentDustGrade: [String] = []
    var currentDustDataCount: Int = 0 {
        didSet {
            oldCurrentDustDataCount = oldValue
        }
    }
    var oldCurrentDustDataCount: Int = 0
    var dustContent: [String] = ["pm10Value", "pm25Value", "so2Value", "coValue", "o3Value", "no2Value"]
    var dustGrade: [String] = ["pm10Grade", "pm25Grade", "so2Grade", "coGrade", "o3Grade", "no2Grade"]
    var dustName: [String] = ["미세먼지", "초미세먼지", "아황산가스", "일산화탄소", "오존", "이산화질소"]
    
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
    
    func changeDustGrade(grade: String?) -> String {
        guard let grade = grade else { return ""}
        switch grade {
        case "1":
            return "좋음"
        case "2":
            return "보통"
        case "3":
            return "나쁨"
        default:
            return "매우나쁨"
        }
    }
    
    func updateWeatherIcon(condition: Int) -> String {
        switch (condition) {
        case 0..<300 :
            return "Thunder"
        case 300..<500 :
            return "Drizzle"
        case 500..<600 :
            return "Rain"
        case 600..<700 :
            return "Snow"
        case 700..<800 :
            return "Mist"
        case 800 :
            return "Clear"
        case 801..<900 :
            return "Cloud"
        case 900...903, 905...1000  :
            return "Wind"
        case 904 :
            return "Clear"
        default:
            return "dunno"
        }
    }
    
}
