
import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherInfo: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var compareLabel: UILabel!
    @IBOutlet weak var dustIcon: UIImageView!
    @IBOutlet weak var dustLabel: UILabel!
    
    let formatter = DateFormatter()
    let locationManager = CLLocationManager()
    var changeAppKeyNum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherDataModel.main.dustData.removeAll()
        WeatherDataModel.main.currentDustData.removeAll()
        WeatherDataModel.main.currentDustGrade.removeAll()
        formatter.dateFormat = "MM월 dd일"
        let currentDate = formatter.string(from: Date())
        dateLabel.text = currentDate
        formatter.dateFormat = "E"
        let currentDay = formatter.string(from: Date())
        dayLabel.text = changeKRDay(str: currentDay)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        WeatherDataModel.main.dustData.removeAll()
        WeatherDataModel.main.currentDustData.removeAll()
        WeatherDataModel.main.currentDustGrade.removeAll()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    @IBAction func toRefershApp(_ sender: UITapGestureRecognizer) {
        WeatherDataModel.main.dustData.removeAll()
        WeatherDataModel.main.currentDustData.removeAll()
        WeatherDataModel.main.currentDustGrade.removeAll()
        formatter.dateFormat = "MM월 dd일"
        let currentDate = formatter.string(from: Date())
        dateLabel.text = currentDate
        formatter.dateFormat = "E"
        let currentDay = formatter.string(from: Date())
        dayLabel.text = changeKRDay(str: currentDay)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func toOpenApp(_ sender: UITapGestureRecognizer) {
        let myAppUrl = URL(string: "TJApp://")!
        extensionContext?.open(myAppUrl, completionHandler: { (success) in
            if (!success) {
                print("///ERROR: failed to open app from Today Extension")
            }
        })
    }
    
    //현재 날짜에 대한 데이터를 한글로 바꾸기 위해 메소드 설정
    func changeKRDay(str: String) -> String {
        switch str {
        case "Mon":
            return "(월)"
        case "Tue" :
            return "(화)"
        case "Wed" :
            return "(수)"
        case "Thu" :
            return "(목)"
        case "Fri" :
            return "(금)"
        case "Sat" :
            return "(토)"
        case "Sun" :
            return "(일)"
        default:
            return "(" + str + ")"
        }
    }
    
    //MARK: - Networking
    //날씨 API JSON 가져오기
    //어제 날씨데이터 가져오기
    func getPrevWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters, headers: SKWeatherHeader).responseJSON { [weak self] response in
            guard let `self` = self else { return }
            if response.result.isSuccess {
                if (JSON(response.result.value!)["weather"]["yesterday"].null != nil) {
                    if self.changeAppKeyNum == 0 {
                        SKWeatherHeader = temp1SKWeatherHeader
                        self.getPrevWeatherData(url: url, parameters: parameters)
                    }else if self.changeAppKeyNum == 1 {
                        SKWeatherHeader = temp2SKWeatherHeader
                        self.getPrevWeatherData(url: url, parameters: parameters)
                    }else {
                        self.locationLabel.text = "트래픽이 초과되어 날씨정보를 받을 수 없습니다."
                    }
                    return
                }
                else if JSON(response.result.value!)["weather"]["yesterday"] == [] {
                    if self.changeAppKeyNum == 0 {
                        SKWeatherHeader = temp1SKWeatherHeader
                    }else if self.changeAppKeyNum == 1 {
                        SKWeatherHeader = temp2SKWeatherHeader
                    }else {
                        self.locationLabel.text = "트래픽이 초과되어 날씨정보를 받을 수 없습니다."
                    }
                    return
                }else {
                    WeatherDataModel.main.prevTemp = Int(round(Double(JSON(response.result.value!)["weather"]["yesterday"][0]["day"]["hourly"][0]["temperature"].stringValue)!))
                    self.getCurrentWeatherData(url: currentSKWeatherURL, parameters: parameters)
                }
            }else {
                print("Error \(response.result.error!)")
                self.locationLabel.text = "Connection Issues"
            }
        }
    }
    
    //현재의 날씨 데이터 가져오기
    func getCurrentWeatherData(url: String, parameters: [String: String]) {
        WeatherDataModel.main.weatherData.removeAll()
        Alamofire.request(url, method: .get, parameters: parameters, headers: SKWeatherHeader).responseJSON { [weak self] response in
            guard let `self` = self else { return }
            if response.result.isSuccess {
                let currentWeatherJSON: JSON = JSON(response.result.value!)
                self.updateCurrentWeatherData(json: currentWeatherJSON)
            }else {
                print("Error \(response.result.error!)")
                self.locationLabel.text = "Connection Issues"
            }
        }
    }
    
    //미세먼지 API JSON 가져오기
    func getTMData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters, headers: kakaoHeaders).responseJSON { response in
            if response.result.isSuccess {
                let data: JSON = JSON(response.result.value!)
                let locationTMx = data["documents"][0]["x"].stringValue
                let locationTMy = data["documents"][0]["y"].stringValue
                let params: [String: String] = ["tmX": locationTMx, "tmY": locationTMy, "pageNo": "1", "numOfRows": "10", "ServiceKey": dustAPIKey, "_returnType": "json"]
                self.getMeasuringStation(url: dustMeasuringStationURL, parameters: params)
            }else {
                print("Error \(response.result.error!)")
            }
        }
    }
    //tmX, tmY로 측정소 이름 가져오기
    func getMeasuringStation(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                let data = JSON(response.result.value!)
                let stationName = data["list"][0]["stationName"].stringValue
                let params: [String: String] = ["stationName": stationName, "dataTerm": "MONTH", "pageNo": "1", "numOfRows": "10", "ServiceKey": dustAPIKey, "ver": "1.3", "_returnType": "json"]
                
                self.getDustData(url: dustDataURL, parameters: params)
            }else {
                print("Error \(response.result.error!)")
            }
        }
    }
    
    //미세먼지 데이터 가져오기
    func getDustData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                let datas = JSON(response.result.value!)
                for data in datas["list"] {
                    guard let dustData = DustModel(json: data) else { return }
                    WeatherDataModel.main.dustData.append(dustData)
                    self.updateUIWithDustData()
                }
            }else {
                print("Error \(response.result.error!)")
            }
        }
    }
    
    //MARK: - JSON Parsing
    //현재 날씨 정보 JSON Parsing
    func updateCurrentWeatherData(json: JSON) {
        if let tempResult = json["weather"]["minutely"][0]["temperature"]["tc"].string {
            WeatherDataModel.main.temperature = Int(round(Double(tempResult)!))
            WeatherDataModel.main.maxTemperature = Int(round(Double(json["weather"]["minutely"][0]["temperature"]["tmax"].stringValue)!))
            WeatherDataModel.main.minTemperature = Int(round(Double(json["weather"]["minutely"][0]["temperature"]["tmin"].stringValue)!))
            WeatherDataModel.main.SKcondition = json["weather"]["minutely"][0]["sky"]["code"].stringValue
            WeatherDataModel.main.weatherIconName = WeatherDataModel.main.changeWeatherCondition(condition: WeatherDataModel.main.SKcondition)
            updateUIWithWeatherDate()
        }else {
            locationLabel.text = "Weather Unavailable"
        }
    }
    
    //MARK: - UI Updates
    func updateUIWithWeatherDate() {
        tempLabel.text = String(WeatherDataModel.main.temperature) + "˚"
        maxTempLabel.text = String(WeatherDataModel.main.maxTemperature) + "˚"
        minTempLabel.text = String(WeatherDataModel.main.minTemperature) + "˚"
        let compareTemp = WeatherDataModel.main.temperature - WeatherDataModel.main.prevTemp
        if compareTemp == 0 {
            compareLabel.text = "어제와 동일합니다"
        }else if compareTemp > 0 {
            compareLabel.text = "어제보다 " + String(compareTemp) + "˚ " + "높습니다"
        }else {
            compareLabel.text = "어제보다 " + String(compareTemp * (-1)) + "˚ " + "낮습니다"
        }
        weatherInfo.text = WeatherDataModel.main.changeKRWeatherCondition(condition: WeatherDataModel.main.weatherIconName)
        var weatherIconName = WeatherDataModel.main.weatherIconName
        formatter.dateFormat = "HH"
        let meridian = Int(formatter.string(from: Date()))

        if meridian! >= 18 || meridian! <= 6 {
            weatherIconName = "Night" + weatherIconName
        }
        weatherIcon.image = UIImage(named: weatherIconName)
    }
    
    func updateUIWithDustData() {
        dustLabel.text = WeatherDataModel.main.changeDustGrade(grade: WeatherDataModel.main.dustData[0].khaiGrade)
        dustIcon.image = UIImage(named: WeatherDataModel.main.changedustIcon(grade: WeatherDataModel.main.dustData[0].khaiGrade))
    }
    
    func getLocationData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters, headers: kakaoHeaders).responseJSON { response in
            if response.result.isSuccess {
                let data: JSON = JSON(response.result.value!)
                self.locationLabel.text = data["documents"][0]["region_2depth_name"].stringValue + " " + data["documents"][0]["region_3depth_name"].stringValue
            }else {
                print("error")
            }
        }
    }
    
    
    //MARK: - Location Manager Delegate
    //didUpdateLocations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            let longitude = String(location.coordinate.longitude)
            let latitude = String(location.coordinate.latitude)
            
            let param: [String: String] = ["lat": latitude, "lon": longitude, "version": "2"]
            let locationParams: [String: String] = ["y": latitude, "x": longitude, "input_coord": "WGS84", "output_coord": "WCONGNAMUL"]
            let tmParams: [String: String] = ["y": latitude, "x": longitude, "input_coord": "WGS84", "output_coord": "WTM"]
            self.getLocationData(url: kakaoGetAddressURL, parameters: locationParams)
            self.getPrevWeatherData(url: historySKWeatherURL, parameters: param)
            self.getTMData(url: kakaoCoordinateURL, parameters: tmParams)
        }
    }
    
    //didFailWithError
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationLabel.text = "Location Unavailable"
    }
    
}
