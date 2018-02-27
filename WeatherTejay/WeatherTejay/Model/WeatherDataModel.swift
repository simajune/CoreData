
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
    var dustGrade: [String] = ["so2Grade", "coGrade", "o3Grade", "no2Grade"]
    var dustName: [String] = ["미세먼지", "초미세먼지", "아황산가스", "일산화탄소", "오존", "이산화질소"]
    var forecastDustDate: [String] = []
    var forecastDustInformCause: [String] = []
    var forecastDustInformOverall: [String] = []
    
    func changeDustGrade(grade: String?) -> String {
        guard let grade = grade else { return "" }
        switch grade {
        case "1":
            return "좋음"
        case "2":
            return "보통"
        case "3":
            return "나쁨"
        case "4":
            return "매우나쁨"
        default:
            return "축정불가"
        }
    }
    
    func changeWHOPM10Grade(value: String) -> String {
        print("10value", value)
        if value == "-" {
            return "5"
        }
        let intValue = Int(value)!
        switch intValue {
        case 0...30:
            return "1"
        case 31...50:
            return "2"
        case 51...100:
            return "3"
        default:
            return "4"
        }
    }
    
    func changeWHOPM25Grade(value: String) -> String {
        print("25value", value)
        if value == "-" {
            return "5"
        }
        let intValue = Int(value)!
        switch intValue {
        case 0...15:
            return "1"
        case 16...25:
            return "2"
        case 26...50:
            return "3"
        default:
            return "4"
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
    
    func changeKRWeatherCondition(condition: String) -> String {
        switch condition {
        case "Thunder":
            return "천둥과 번개"
        case "Drizzle":
            return "이슬비"
        case "Rain":
            return "비"
        case "Snow":
            return "눈"
        case "Mist":
            return "안개"
        case "Clear":
            return "맑음"
        case "Cloud":
            return "흐림"
        case "Wind":
            return "강한 바람"
        default:
            return "알수 없음"
        }
    }
    
    func changedustIcon(grade: String?)-> String {
        guard let grade = grade else { return "SoBad"}
        switch grade {
        case "1":
            return "SoGood"
        case "2":
            return "Good"
        case "3":
            return "Bad"
        default:
            return "SoBad"
        }
    }
}
