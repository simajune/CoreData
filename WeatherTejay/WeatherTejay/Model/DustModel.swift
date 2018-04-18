
import Foundation
import SwiftyJSON

struct DustModel {
    
    //var address: String?
    //측정일 2016-04-20 14:00 yyyy-MM-dd HH:mm
    var dateTime: Date?
    //측정망 정보 (국가배경, 교외대기, 도시대기, 도로변대기)
    var mangName: String?
    //아황산가스 농도 (단위 : ppm)
    var so2Value: String?
    //일산화탄소 농도 (단위 : ppm)
    var coValue: String?
    //오존 농도 (단위 : ppm)
    var o3Value: String?
    //이산화질소 농도 (단위 : ppm)
    var no2Value: String?
    //미세먼지(PM10) 농도 (단위 : ㎍/㎥)
    var pm10Value: String?
    //미세먼지(PM10) 24시간예측이동농도 (단위 : ㎍/㎥)
    var pm10Value24: String?
    //미세먼지(PM2.5)  농도 (단위 : ㎍/㎥)
    var pm25Value: String?
    //미세먼지(PM2.5) 24시간예측이동농도 (단위 : ㎍/㎥)
    var pm25Value24: String?
    //통합대기환경수치
    var khaiValue: String?
    //통합대기환경지수
    var khaiGrade: String?
    //아황산가스 지수
    var so2Grade: String?
    //일산화탄소 지수
    var coGrade: String?
    //오존 지수
    var o3Grade: String?
    //이산화질소 지수
    var no2Grade: String?
    //미세먼지(PM10) 24시간 등급자료
    var pm10Grade: String?
    //미세먼지(PM2.5) 24시간 등급자료
    var pm25Grade: String?
    //미세먼지(PM10) 1시간 등급
    var pm10Grade1h: String?
    //미세먼지(PM2.5) 1시간 등급
    var pm25Grade1h: String?
    
//    등급       Grade 값
//    좋음       1
//    보통       2
//    나쁨       3
//    매우나쁨    4
    
    init?(data: JSON) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd kk:mm"
        guard let mangName = data["mangName"].string else { return nil }
        self.mangName = mangName
        guard let so2Value = data["so2Value"].string else { return nil }
        self.so2Value = so2Value
        guard let coValue = data["coValue"].string else { return nil }
        self.coValue = coValue
        guard let o3Value = data["o3Value"].string else { return nil }
        self.o3Value = o3Value
        guard let no2Value = data["no2Value"].string else { return nil }
        self.no2Value = no2Value
        guard let pm10Value = data["pm10Value"].string else { return nil }
        self.pm10Value = pm10Value
        guard let pm10Value24 = data["pm10Value24"].string else { return nil }
        self.pm10Value24 = pm10Value24
        guard let pm25Value = data["pm25Value"].string else { return nil }
        self.pm25Value = pm25Value
        guard let pm25Value24 = data["pm25Value24"].string else { return nil }
        self.pm25Value24 = pm25Value24
        guard let khaiValue = data["khaiValue"].string else { return nil }
        self.khaiValue = khaiValue
        guard let khaiGrade = data["khaiGrade"].string else { return nil }
        self.khaiGrade = khaiGrade
        guard let so2Grade = data["so2Grade"].string else { return nil }
        self.so2Grade = so2Grade
        guard let coGrade = data["coGrade"].string else { return nil }
        self.coGrade = coGrade
        guard let no2Grade = data["no2Grade"].string else { return nil }
        self.no2Grade = no2Grade
        guard let pm10Grade = data["pm10Grade"].string else { return nil }
        self.pm10Grade = pm10Grade
        guard let pm25Grade = data["pm25Grade"].string else { return nil }
        self.pm25Grade = pm25Grade
        guard let pm10Grade1h = data["pm10Grade1h"].string else { return nil }
        self.pm10Grade1h = pm10Grade1h
        guard let pm25Grade1h = data["pm25Grade1h"].string else { return nil }
        self.pm25Grade1h = pm25Grade1h
        
    }
    
    init?(json: (String, JSON)) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd kk:mm"
        guard let dateTime = dateformatter.date(fromSwapiString: json.1["dataTime"].stringValue) else { return nil }
        self.dateTime = dateTime
        guard let mangName = json.1["mangName"].string else { return nil }
        self.mangName = mangName
        guard let so2Value = json.1["so2Value"].string else { return nil }
        self.so2Value = so2Value
        guard let coValue = json.1["coValue"].string else { return nil }
        self.coValue = coValue
        guard let o3Value = json.1["o3Value"].string else { return nil }
        self.o3Value = o3Value
        guard let no2Value = json.1["no2Value"].string else { return nil }
        self.no2Value = no2Value
        guard let pm10Value = json.1["pm10Value"].string else { return nil }
        self.pm10Value = pm10Value
        guard let pm10Value24 = json.1["pm10Value24"].string else { return nil }
        self.pm10Value24 = pm10Value24
        guard let pm25Value = json.1["pm25Value"].string else { return nil }
        self.pm25Value = pm25Value
        guard let pm25Value24 = json.1["pm25Value24"].string else { return nil }
        self.pm25Value24 = pm25Value24
        guard let khaiValue = json.1["khaiValue"].string else { return nil }
        self.khaiValue = khaiValue
        guard let khaiGrade = json.1["khaiGrade"].string else { return nil }
        self.khaiGrade = khaiGrade
        guard let so2Grade = json.1["so2Grade"].string else { return nil }
        self.so2Grade = so2Grade
        guard let coGrade = json.1["coGrade"].string else { return nil }
        self.coGrade = coGrade
        guard let no2Grade = json.1["no2Grade"].string else { return nil }
        self.no2Grade = no2Grade
        guard let pm10Grade = json.1["pm10Grade"].string else { return nil }
        self.pm10Grade = pm10Grade
        guard let pm25Grade = json.1["pm25Grade"].string else { return nil }
        self.pm25Grade = pm25Grade
        guard let pm10Grade1h = json.1["pm10Grade1h"].string else { return nil }
        self.pm10Grade1h = pm10Grade1h
        guard let pm25Grade1h = json.1["pm25Grade1h"].string else { return nil }
        self.pm25Grade1h = pm25Grade1h
    }
    
    init?(dic: [String: String]) {
        guard let mangName = dic["mangName"] else { return nil }
        self.mangName = mangName
        guard let so2Value = dic["so2Value"] else { return nil }
        self.so2Value = so2Value
        guard let coValue = dic["coValue"] else { return nil }
        self.coValue = coValue
        guard let o3Value = dic["o3Value"] else { return nil }
        self.o3Value = o3Value
        guard let no2Value = dic["no2Value"] else { return nil }
        self.no2Value = no2Value
        guard let pm10Value = dic["pm10Value"] else { return nil }
        self.pm10Value = pm10Value
        guard let pm10Value24 = dic["pm10Value24"] else { return nil }
        self.pm10Value24 = pm10Value24
        guard let pm25Value = dic["pm25Value"] else { return nil }
        self.pm25Value = pm25Value
        guard let pm25Value24 = dic["pm25Value24"] else { return nil }
        self.pm25Value24 = pm25Value24
        guard let khaiValue = dic["khaiValue"] else { return nil }
        self.khaiValue = khaiValue
        guard let khaiGrade = dic["khaiGrade"] else { return nil }
        self.khaiGrade = khaiGrade
        guard let so2Grade = dic["so2Grade"] else { return nil }
        self.so2Grade = so2Grade
        guard let coGrade = dic["coGrade"] else { return nil }
        self.coGrade = coGrade
        guard let no2Grade = dic["no2Grade"] else { return nil }
        self.no2Grade = no2Grade
        guard let pm10Grade = dic["pm10Grade"] else { return nil }
        self.pm10Grade = pm10Grade
        guard let pm25Grade = dic["pm25Grade"] else { return nil }
        self.pm25Grade = pm25Grade
        guard let pm10Grade1h = dic["pm10Grade1h"] else { return nil }
        self.pm10Grade1h = pm10Grade1h
        guard let pm25Grade1h = dic["pm25Grade1h"] else { return nil }
        self.pm25Grade1h = pm25Grade1h
    }
}
