
import Foundation
import SwiftyJSON

struct DustModel {
    
    //var address: String?
    //측정일 2016-04-20 14:00 yyyy-MM-dd HH:mm
    var dataTime: Date?
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
    
    init?(json: JSON) {
        let dateformater = DateFormatter()
        dateformater.dateFormat = "yyyy-MM-dd HH:mm"
        guard let dataTime = dateformater.date(fromSwapiString: json["dataTime"].stringValue) else { return nil }
        self.dataTime = dataTime
        guard let mangName = json["mangName"].string else { return nil }
        self.mangName = mangName
        guard let so2Value = json["so2Value"].string else { return nil }
        self.so2Value = so2Value
        guard let coValue = json["coValue"].string else { return nil }
        self.coValue = coValue
        guard let o3Value = json["o3Value"].string else { return nil }
        self.o3Value = o3Value
        guard let no2Value = json["no2Value"].string else { return nil }
        self.no2Value = no2Value
        guard let pm10Value = json["pm10Value"].string else { return nil }
        self.pm10Value = pm10Value
        guard let pm10Value24 = json["pm10Value24"].string else { return nil }
        self.pm10Value24 = pm10Value24
        guard let pm25Value = json["pm25Value"].string else { return nil }
        self.pm25Value = pm25Value
        guard let pm25Value24 = json["pm25Value24"].string else { return nil }
        self.pm25Value24 = pm25Value24
        guard let khaiValue = json["khaiValue"].string else { return nil }
        self.khaiValue = khaiValue
        guard let khaiGrade = json["khaiGrade"].string else { return nil }
        self.khaiGrade = khaiGrade
        guard let so2Grade = json["so2Grade"].string else { return nil }
        self.so2Grade = so2Grade
        guard let coGrade = json["coGrade"].string else { return nil }
        self.coGrade = coGrade
        guard let no2Grade = json["no2Grade"].string else { return nil }
        self.no2Grade = no2Grade
        guard let pm10Grade = json["pm10Grade"].string else { return nil }
        self.pm10Grade = pm10Grade
        guard let pm25Grade = json["pm25Grade"].string else { return nil }
        self.pm25Grade = pm25Grade
        guard let pm10Grade1h = json["pm10Grade1h"].string else { return nil }
        self.pm10Grade1h = pm10Grade1h
        guard let pm25Grade1h = json["pm25Grade1h"].string else { return nil }
        self.pm25Grade1h = pm25Grade1h
    }
}
