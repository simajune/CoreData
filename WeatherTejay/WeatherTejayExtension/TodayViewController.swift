
import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
    
    //MARK: - IBOutlet
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
    let dataModel = DataModel()
    var changeAppKeyNum: Int = 0
    var stationList: [String] = []
    var dustParams: [String: String] = [:]
    var changeDustNum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataModel.main.dustData.removeAll()
        DataModel.main.currentDustData.removeAll()
        DataModel.main.currentDustGrade.removeAll()
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
        DataModel.main.dustData.removeAll()
        DataModel.main.currentDustData.removeAll()
        DataModel.main.currentDustGrade.removeAll()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    //PM10데이터 값에 따른 등급을 WHO기준으로 변환
    private func changeWHOPM10Grade(value: String) -> String {
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
    
    //PM2.5데이터 값에 따른 등급을 WHO기준으로 변환
    private func changeWHOPM25Grade(value: String) -> String {
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
    
    //위젯 한번 눌렀을 때 앱으로 들어감
    @IBAction func toRefershApp(_ sender: UITapGestureRecognizer) {
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
    
    //위젯 두번 눌렀을 때 앱으로 들어감
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
                        self.changeAppKeyNum += 1
                        self.getPrevWeatherData(url: url, parameters: parameters)
                    }else if self.changeAppKeyNum == 1 {
                        SKWeatherHeader = temp2SKWeatherHeader
                        self.changeAppKeyNum += 1
                        self.getPrevWeatherData(url: url, parameters: parameters)
                    }else {
                        self.locationLabel.text = "트래픽이 초과되어 날씨정보를 받을 수 없습니다."
                        self.changeAppKeyNum = 0
                    }
                }
                else if JSON(response.result.value!)["weather"]["yesterday"] == [] {
                    if self.changeAppKeyNum == 0 {
                        self.changeAppKeyNum += 1
                        SKWeatherHeader = temp1SKWeatherHeader
                        self.getPrevWeatherData(url: url, parameters: parameters)
                    }else if self.changeAppKeyNum == 1 {
                        self.changeAppKeyNum += 1
                        SKWeatherHeader = temp2SKWeatherHeader
                        self.getPrevWeatherData(url: url, parameters: parameters)
                    }else {
                        self.locationLabel.text = "트래픽이 초과되어 날씨정보를 받을 수 없습니다."
                        self.changeAppKeyNum = 0
                    }
                }else {
                    self.changeAppKeyNum = 0
                    DataModel.main.prevTemp = Int(round(Double(JSON(response.result.value!)["weather"]["yesterday"][0]["day"]["hourly"][0]["temperature"].stringValue)!))
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
        DataModel.main.weatherData.removeAll()
        Alamofire.request(url, method: .get, parameters: parameters, headers: SKWeatherHeader).responseJSON { [weak self] response in
            guard let `self` = self else { return }
            if response.result.isSuccess {
                let data: JSON = JSON(response.result.value!)
                if data["weather"]["minutely"] == [] || data["weather"]["minutely"].null != nil {
                    if self.changeAppKeyNum == 0 {
                        SKWeatherHeader = temp1SKWeatherHeader
                        self.changeAppKeyNum += 1
                        self.getPrevWeatherData(url: url, parameters: parameters)
                    }else if self.changeAppKeyNum == 1 {
                        SKWeatherHeader = temp2SKWeatherHeader
                        self.changeAppKeyNum += 1
                        self.getPrevWeatherData(url: url, parameters: parameters)
                    }else {
                        self.locationLabel.text = "트래픽이 초과되어 날씨정보를 받을 수 없습니다."
                        self.changeAppKeyNum = 0
                    }
                }else {
                    self.changeAppKeyNum = 0
                    self.updateCurrentWeatherData(json: data)
                }
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
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [weak self] response in
            guard let `self` = self else { return }
            if response.result.isSuccess {
                let data = JSON(response.result.value!)
                //변수값 초기화
                self.stationList.removeAll()
                self.changeDustNum = 0
                //현재 위치에서 거리순으로 가까운 측정소 3곳을 저장
                for list in data["list"] {
                    self.stationList.append(list.1["stationName"].stringValue)
                }
                
                self.dustParams = ["stationName": self.stationList[self.changeDustNum], "dataTerm": "MONTH", "pageNo": "1", "numOfRows": "10", "ServiceKey": dustAPIKey, "ver": "1.3", "_returnType": "json"]
                self.getDustData(url: dustDataURL, parameters: self.dustParams)
            }else {
                dustAPIKey = originalAPIKey
                print("Error \(response.result.error!)")
            }
        }
    }
    
    //미세먼지 데이터 가져오기
    func getDustData(url: String, parameters: [String: String]) {
        DataModel.main.dustData.removeAll()
        DataModel.main.currentDustGrade.removeAll()
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                let datas = JSON(response.result.value!)
                //만약 측정소의 문제로 인해 미세먼지의 값이 나오지 않을 경우 근처의 다른 측정소의 정보를 가져옴
                if datas["list"][0]["pm10Value"].stringValue == "-" || datas["list"][0]["pm25Value"].stringValue == "-" {
                    if self.changeDustNum < 2 {
                        self.changeDustNum += 1
                        self.dustParams = ["stationName": self.stationList[self.changeDustNum], "dataTerm": "MONTH", "pageNo": "1", "numOfRows": "10", "ServiceKey": dustAPIKey, "ver": "1.3", "_returnType": "json"]
                        self.getDustData(url: dustDataURL, parameters: self.dustParams)
                    }
                    else {
                        //메세지 띄우기
                    }
                }else {
                    for data in datas["list"] {
                        guard let dustData = DustModel(json: data) else { return }
                        DataModel.main.dustData.append(dustData)
                    }
                    
                    DataModel.main.currentDustGrade.append(self.changeWHOPM10Grade(value: datas["list"][0]["pm10Value"].stringValue))
                    DataModel.main.currentDustGrade.append(self.changeWHOPM25Grade(value: datas["list"][0]["pm25Value"].stringValue))
                    if datas["list"][0]["khaiValue"].stringValue == "-" {
                        self.dustLabel.text = DataModel.main.changeDustGrade(grade: DataModel.main.currentDustGrade[0])
                        self.dustIcon.image = UIImage(named: DataModel.main.changedustIcon(grade: DataModel.main.currentDustGrade[0]))
                    }else {
                        //만약 미세먼지나 초미세먼지의 등급이 하나라도 '나쁨'이나 '매우나쁨'일 경우 등급은 미세먼지, 초미세먼지의 등급으로 표시
                        for list in DataModel.main.currentDustGrade {
                            if list == "3" || list == "4" {
                                self.dustLabel.text = DataModel.main.changeDustGrade(grade: list)
                                self.dustIcon.image = UIImage(named: DataModel.main.changedustIcon(grade: list))
                            }else{
                                self.dustLabel.text = DataModel.main.changeDustGrade(grade: DataModel.main.dustData[0].khaiGrade)
                                self.dustIcon.image = UIImage(named: DataModel.main.changedustIcon(grade: DataModel.main.dustData[0].khaiGrade))
                            }
                        }
                    }
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
            DataModel.main.temperature = Int(round(Double(tempResult)!))
            DataModel.main.maxTemperature = Int(round(Double(json["weather"]["minutely"][0]["temperature"]["tmax"].stringValue)!))
            DataModel.main.minTemperature = Int(round(Double(json["weather"]["minutely"][0]["temperature"]["tmin"].stringValue)!))
            DataModel.main.SKcondition = json["weather"]["minutely"][0]["sky"]["code"].stringValue
            DataModel.main.weatherIconName = DataModel.main.changeWeatherCondition(condition: DataModel.main.SKcondition)
            updateUIWithWeatherDate()
        }else {
            locationLabel.text = "Weather Unavailable"
        }
    }
    
    //MARK: - UI Updates
    func updateUIWithWeatherDate() {
        tempLabel.text = String(DataModel.main.temperature) + "˚"
        maxTempLabel.text = String(DataModel.main.maxTemperature) + "˚"
        minTempLabel.text = String(DataModel.main.minTemperature) + "˚"
        let compareTemp = DataModel.main.temperature - DataModel.main.prevTemp
        if compareTemp == 0 {
            compareLabel.text = "어제와 동일합니다"
        }else if compareTemp > 0 {
            compareLabel.text = "어제보다 " + String(compareTemp) + "˚ " + "높습니다"
        }else {
            compareLabel.text = "어제보다 " + String(compareTemp * (-1)) + "˚ " + "낮습니다"
        }
        weatherInfo.text = DataModel.main.changeKRWeatherCondition(condition: DataModel.main.weatherIconName)
        var weatherIconName = DataModel.main.weatherIconName
        formatter.dateFormat = "HH"
        let meridian = Int(formatter.string(from: Date()))

        if meridian! >= 18 || meridian! <= 6 {
            weatherIconName = "Night" + weatherIconName
        }
        weatherIcon.image = UIImage(named: weatherIconName)
    }
    
    func updateUIWithDustData() {
        dustLabel.text = DataModel.main.changeDustGrade(grade: DataModel.main.dustData[0].khaiGrade)
        dustIcon.image = UIImage(named: DataModel.main.changedustIcon(grade: DataModel.main.dustData[0].khaiGrade))
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
