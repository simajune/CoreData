
import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

protocol MainDelegate {
    func updateCell(count: Int)
}

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    
    var delegate: MainDelegate?
    //Variable
    let locationManager = CLLocationManager()
    //let weatherDataModel = WeatherDataModel()
    let formatter = DateFormatter()
    
    
    @IBOutlet weak var backGroundImgView: UIImageView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var dustLabel: UILabel!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    func changeKRDay(str: String) -> String {
        switch str {
        case "Mon":
            return "월요일"
        case "Tue" :
            return "화요일"
        case "Wed" :
            return "수요일"
        case "Thu" :
            return "목요일"
        case "Fri" :
            return "금요일"
        case "Sat" :
            return "토요일"
        case "Sun" :
            return "일요일"
        default:
            return str + "요일"
        }
    }
    
    @IBAction func refreshAction(_ sender: UIButton) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatter.dateFormat = "MM월 dd일"
        let currentDate = formatter.string(from: Date())
        dateLabel.text = currentDate
        formatter.dateFormat = "E"
        let currentDay = formatter.string(from: Date())
        dayLabel.text = changeKRDay(str: currentDay)
        
        locationLabel.text = WeatherDataModel.main.address
        if WeatherDataModel.main.weatherLocationX != "" && WeatherDataModel.main.weatherLocationX != "" {
            let params: [String: String] = ["lat": WeatherDataModel.main.weatherLocationY, "lon": WeatherDataModel.main.weatherLocationX, "appid": weatherAPIKey]
            let tmParams: [String: String] = ["y": WeatherDataModel.main.weatherLocationY, "x": WeatherDataModel.main.weatherLocationX, "input_coord": "WGS84", "output_coord": "WTM"]
            getforecastWeatherData(url: weatherURL, parameters: params)
            getCurrentWeatherData(url: currentWeatherURL, parameters: params)
            getTMData(url: kakaoCoordinateURL, parameters: tmParams)
        }
    }
    
    //MARK: - Btn Add Ta
    
    //MARK: - Networking
    //날씨 API JSON 가져오기
    
    func getCurrentWeatherData(url: String, parameters: [String: String]) {
        WeatherDataModel.main.weatherData.removeAll()
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                print("Success! Got the weather data")
                let currentWeatherJSON: JSON = JSON(response.result.value!)
                self.updateCurrentWeatherData(json: currentWeatherJSON)
            }else {
                print("Error \(response.result.error!)")
                self.locationLabel.text = "Connection Issues"
            }
        }
    }
    
    func getforecastWeatherData(url: String, parameters: [String: String]) {
        WeatherDataModel.main.weatherData.removeAll()
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                print("Success! Got the weather data")
                let weatherJSON: JSON = JSON(response.result.value!)
                self.updateforecastWeatherData(json: weatherJSON)
            }else {
                print("Error \(response.result.error!)")
                self.locationLabel.text = "Connection Issues"
            }
        }
    }
    
    //미세먼지 API JSON 가져오가
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
                //print("measutingStation", data)
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
        WeatherDataModel.main.dustData.removeAll()
        WeatherDataModel.main.currentDustData.removeAll()
        WeatherDataModel.main.currentDustGrade.removeAll()
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                let datas = JSON(response.result.value!)
                for title in WeatherDataModel.main.dustContent {
                    WeatherDataModel.main.currentDustData.append(datas["list"][0][title].stringValue)
                }
                for title in WeatherDataModel.main.dustGrade {
                    WeatherDataModel.main.currentDustGrade.append(datas["list"][0][title].stringValue)
                }
//                print(WeatherDataModel.main.currentDustGrade)
                WeatherDataModel.main.currentDustDataCount = WeatherDataModel.main.currentDustData.count
                self.dustLabel.text = WeatherDataModel.main.changeDustGrade(grade: WeatherDataModel.main.currentDustGrade[0])
                for data in datas["list"] {
                    guard let dustData = DustModel(json: data) else { return }
                    WeatherDataModel.main.dustData.append(dustData)
                }
                self.weatherCollectionView.reloadData()
            }else {
                print("Error \(response.result.error!)")
            }
            //self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK: - JSON Parsing
    func updateforecastWeatherData(json: JSON) {
        if let tempResult = json["list"][0]["main"]["temp"].double {
            WeatherDataModel.main.temperature = Int(tempResult - 273.15)
            WeatherDataModel.main.maxTemperature = Int(json["list"][0]["main"]["temp_max"].doubleValue - 273.15)
            WeatherDataModel.main.minTemperature = Int(json["list"][0]["main"]["temp_min"].doubleValue - 273.15)
            WeatherDataModel.main.condition = json["list"][0]["weather"][0]["id"].intValue
            WeatherDataModel.main.weatherIconName = WeatherDataModel.main.updateWeatherIcon(condition: WeatherDataModel.main.condition)
            for index in json["list"] {
                guard let weatherData = WeatherModel(json: index) else { return }
                WeatherDataModel.main.weatherData.append(weatherData)
            }
            WeatherDataModel.main.forecastCount = json["list"].count - 1
    
            weatherCollectionView.reloadData()
            //updateUIWithWeatherDate()
        }else {
            locationLabel.text = "Weather Unavailable"
        }
    }
    
    func updateCurrentWeatherData(json: JSON) {
        if let tempResult = json["main"]["temp"].double {
            WeatherDataModel.main.temperature = Int(tempResult - 273.15)
            WeatherDataModel.main.maxTemperature = Int(json["main"]["temp_max"].doubleValue - 273.15)
            WeatherDataModel.main.minTemperature = Int(json["main"]["temp_min"].doubleValue - 273.15)
            WeatherDataModel.main.condition = json["weather"][0]["id"].intValue
            WeatherDataModel.main.weatherIconName = WeatherDataModel.main.updateWeatherIcon(condition: WeatherDataModel.main.condition)
            
            updateUIWithWeatherDate()
        }else {
            locationLabel.text = "Weather Unavailable"
        }
    }
    
    
    //MARK: - UI Updates
    func updateUIWithWeatherDate() {
        //locationLabel.text = WeatherDataModel.main.city
        tempLabel.text = String(WeatherDataModel.main.temperature) + "˚"
        maxTempLabel.text = String(WeatherDataModel.main.maxTemperature) + "˚"
        minTempLabel.text = String(WeatherDataModel.main.minTemperature) + "˚"
        var weatherIconName = WeatherDataModel.main.weatherIconName
        formatter.dateFormat = "a"
        let meridian = formatter.string(from: Date())
        if meridian == "PM" {
            weatherIconName = "Night" + weatherIconName
        }
        weatherIcon.image = UIImage(named: weatherIconName)
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
            //print("long = \(location.coordinate.longitude), lat = \(location.coordinate.latitude)")
            let longitude = String(location.coordinate.longitude)
            let latitude = String(location.coordinate.latitude)
//            print("long", longitude)
//            print("lat", latitude)
            
            let param: [String: String] = ["lat": latitude, "lon": longitude, "appid": weatherAPIKey]
            let locationParams: [String: String] = ["y": latitude, "x": longitude, "input_coord": "WGS84", "output_coord": "WCONGNAMUL"]
            let tmParams: [String: String] = ["y": latitude, "x": longitude, "input_coord": "WGS84", "output_coord": "WTM"]
            
            getLocationData(url: kakaoGetAddressURL, parameters: locationParams)
            getCurrentWeatherData(url: currentWeatherURL, parameters: param)
            getforecastWeatherData(url: weatherURL, parameters: param)
            getTMData(url: kakaoCoordinateURL, parameters: tmParams)
        }
    }
    
    //didFailWithError
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationLabel.text = "Location Unavailable"
    }
    
    func updateForecastweather() {
        
    }


}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 1 {
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "cellB", for: indexPath) as! CellB
            cellB.cellCount = WeatherDataModel.main.currentDustDataCount
//            print(WeatherDataModel.main.currentDustDataCount)
            if WeatherDataModel.main.currentDustDataCount == WeatherDataModel.main.oldCurrentDustDataCount {
                cellB.dustTableView.reloadData()
            }
//            print("cellBCount: ", cellB.cellCount)
            return cellB
        } else {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "cellA", for: indexPath) as! CellA
            cellA.cellCount = WeatherDataModel.main.forecastCount
            if WeatherDataModel.main.forecastCount == WeatherDataModel.main.preforecastCount {
                cellA.forecastCollectionView.reloadData()
            }
//            print("cellACount: ", cellA.cellCount)
            return cellA
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 1 {
            return CGSize(width: self.view.frame.width, height: (self.weatherCollectionView.frame.maxY - weatherCollectionView.frame.minY - 100 - 2))
        }else {
            return CGSize(width: self.view.frame.width, height: 100)
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
}
