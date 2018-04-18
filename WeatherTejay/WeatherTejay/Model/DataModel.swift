
import Foundation

class DataModel {
    
    //날씨 데이터
    var address: String = ""
    var temperature: Int = 0
    var prevTemp: Int = 0
    var maxTemperature: Int = 0
    var minTemperature: Int = 0
    var condition: Int = 0
    var SKcondition: String = ""
    var forecastCount: Int = 0 {
        didSet{
            preforecastCount = oldValue
        }
    }
    var preforecastCount: Int = 0
    var city: String = ""
    var weatherIconName: String = ""
    var weatherInfo: String = ""
    var weatherDate: [Date] = []
    var weatherLocationX: String = ""
    var weatherLocationY: String = ""
    var weatherData: [[String: String]] = []
    var weathercontents: [String: String] = [:]
    
    //미세먼지 데이터
    var dustData: [DustModel] = []
    var sampleDustData: [[String: String]] = []
    var sampleDustDataElement: [String: String] = [:]
    var currentDustData: [String] = []
    var currentDustGrade: [String] = []
    var currentDustDataCount: Int = 0 {
        didSet {
            oldCurrentDustDataCount = oldValue
        }
    }
    var forecastDustDateCount: Int = 0 {
        didSet {
            oldforecastDustDateCount = oldValue
        }
    }
    var oldforecastDustDateCount: Int = 0
    var oldCurrentDustDataCount: Int = 0
    var dustContent: [String] = ["pm10Value", "pm25Value", "so2Value", "coValue", "o3Value", "no2Value"]
    var dustGrade: [String] = ["so2Grade", "coGrade", "o3Grade", "no2Grade"]
    var dustName: [String] = ["미세먼지", "초미세먼지", "아황산가스", "일산화탄소", "오존", "이산화질소"]
    var forecastDustDate: [String] = []
    var forecastDustInformCause: [String] = []
    var forecastDustInformOverall: [String] = []
    
    //미세먼지 상태를 반환하기 위한 메소드
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
            return "측정불가"
        }
    }
    
    func toDicDustData(dustData: [DustModel]) -> [String: String]{
        var sampleDustDataElement: [String: String] = [:]
        sampleDustDataElement["mangName"] = dustData[0].mangName
        //아황산가스 농도 (단위 : ppm)
        sampleDustDataElement["so2Value"] = dustData[0].so2Value
        //일산화탄소 농도 (단위 : ppm)
        sampleDustDataElement["coValue"] = dustData[0].coValue
        //오존 농도 (단위 : ppm)
        sampleDustDataElement["o3Value"] = dustData[0].o3Value
        //이산화질소 농도 (단위 : ppm)
        sampleDustDataElement["no2Value"] = dustData[0].no2Value
        //미세먼지(PM10) 농도 (단위 : ㎍/㎥)
        sampleDustDataElement["pm10Value"] = dustData[0].pm10Value
        //미세먼지(PM10) 24시간예측이동농도 (단위 : ㎍/㎥)
        sampleDustDataElement["pm10Value24"] = dustData[0].pm10Value24
        //미세먼지(PM2.5)  농도 (단위 : ㎍/㎥)
        sampleDustDataElement["pm25Value"] = dustData[0].pm25Value
        //미세먼지(PM2.5) 24시간예측이동농도 (단위 : ㎍/㎥)
        sampleDustDataElement["pm25Value24"] = dustData[0].pm25Value24
        //통합대기환경수치
        sampleDustDataElement["khaiValue"] = dustData[0].khaiValue
        //통합대기환경지수
        sampleDustDataElement["khaiGrade"] = dustData[0].khaiGrade
        //아황산가스 지수
        sampleDustDataElement["so2Grade"] = dustData[0].so2Grade
        //일산화탄소 지수
        sampleDustDataElement["coGrade"] = dustData[0].coGrade
        //오존 지수
        sampleDustDataElement["o3Grade"] = dustData[0].o3Grade
        //이산화질소 지수
        sampleDustDataElement["no2Grade"] = dustData[0].no2Grade
        //미세먼지(PM10) 24시간 등급자료
        sampleDustDataElement["pm10Grade"] = dustData[0].pm10Grade
        //미세먼지(PM2.5) 24시간 등급자료
        sampleDustDataElement["pm25Grade"] = dustData[0].pm25Grade
        //미세먼지(PM10) 1시간 등급
        sampleDustDataElement["pm10Grade1h"] = dustData[0].pm10Grade1h
        //미세먼지(PM2.5) 1시간 등급
        sampleDustDataElement["pm25Grade1h"] = dustData[0].pm25Grade1h
        return sampleDustDataElement
    }
    
    //날씨의 이이콘에 대한 값을 반환하기 위한 메소드 (Openweathermap)
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
    
    //날씨의 이이콘에 대한 값을 반환하기 위한 메소드 (SKWeather API)
    func changeWeatherCondition(condition: String) -> String {
        var condition = condition.replace(target: "SKY_A", withString: "")
        condition = condition.replace(target: "SKY_S", withString: "")
        condition = condition.replace(target: "SKY_O", withString: "")
        condition = condition.replace(target: "SKY_Y", withString: "")
        switch condition {
        case "01":
            return "Clear"
        case "02":
            return "PartlyCloud"
        case "03", "07":
            return "Cloud"
        case "04", "08":
            return "Rain"
        case "05", "09":
            return "Snow"
        case "06", "10":
            return "RainSnow"
        case "11":
            return "Thunder"
        case "12":
            return "RainThunder"
        case "13":
            return "SnowThunder"
        case "14":
            return "RainSnowThunder"
        default:
            return "dunno"
        }
    }
    
    //날씨의 상태(한글) 반환하기 위한 메소드
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
    
    //미세먼지 아이콘 값을 반환하기 위한 메소드
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
