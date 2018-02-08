
import Foundation
import SwiftyJSON

struct WeatherModel {
    var temp: Int?
    var tempMax: Int?
    var tempMin: Int?
    var condition: Int?
    var date: Date?
    
    init?(json: (String, JSON)) {
        let dateformater = DateFormatter()
        dateformater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let temp = json.1["main"]["temp"].double else { return nil }
        let tempInt = Int(temp - 273.15)
        self.temp = tempInt
        guard let tempMaximum = json.1["main"]["temp_max"].double else { return nil }
        let tempMax = Int(tempMaximum - 273.15)
        self.tempMax = tempMax
        guard let tempMinimum = json.1["main"]["temp_min"].double else { return nil }
        let tempMin = Int(tempMinimum)
        self.tempMin = tempMin
        guard let condition = json.1["weather"][0]["id"].int else { return nil }
        self.condition = condition
        guard let date =  dateformater.date(fromSwapiString: json.1["dt_txt"].stringValue) else { return nil }
        self.date = date
    }
}
