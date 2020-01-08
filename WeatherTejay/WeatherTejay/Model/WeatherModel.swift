
import Foundation
import SwiftyJSON

struct WeatherModel {
    var temp: Int?
    var condition: Int?
    var date: Date?
    
    init?(json: (String, JSON)) {
        let dateformater = DateFormatter()
        dateformater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let temp = json.1["main"]["temp"].double else { return nil }
        let tempInt = Int(temp - 273.15)
        self.temp = tempInt
        guard let condition = json.1["weather"][0]["id"].int else { return nil }
        self.condition = condition
        guard let date =  dateformater.date(fromSwapiString: json.1["dt_txt"].stringValue) else { return nil }
        self.date = date
    }
}
