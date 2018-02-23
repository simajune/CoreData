
import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import PKHUD

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    //Variable
    let locationManager = CLLocationManager()
    let formatter = DateFormatter()
    var sectionIsExpanded = false
    
    //IBOutlet
    @IBOutlet weak var backGroundImgView: UIImageView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherInfo: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var dustIcon: UIImageView!
    @IBOutlet weak var dustLabel: UILabel!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var refreshBtn: UIButton!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //위치 정보를 받기 위함 설정들
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //메뉴 버튼에 대한 메소드 설정
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        //매뉴를 보기 위한 조건들 추가 - 오른쪽으로 슬라이드
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //현재의 날을 받아와서 뷰의 나타내기
        formatter.dateFormat = "MM월 dd일"
        let currentDate = formatter.string(from: Date())
        dateLabel.text = currentDate
        //현재 요일을 받아오기
        formatter.dateFormat = "E"
        let currentDay = formatter.string(from: Date())
        dayLabel.text = changeKRDay(str: currentDay)
        //이건 주소 검색에서 주소를 클릭했을 때 불려지게 하기 위함. 왜냐하면 검색한 주소에 대한 정보를 보내기 위해선 'viewWillAppear' 메소드에 설정함
        locationLabel.text = WeatherDataModel.main.address
        if WeatherDataModel.main.weatherLocationX != "" && WeatherDataModel.main.weatherLocationX != "" {
            let params: [String: String] = ["lat": WeatherDataModel.main.weatherLocationY, "lon": WeatherDataModel.main.weatherLocationX, "appid": weatherAPIKey]
            let tmParams: [String: String] = ["y": WeatherDataModel.main.weatherLocationY, "x": WeatherDataModel.main.weatherLocationX, "input_coord": "WGS84", "output_coord": "WTM"]
            getforecastWeatherData(url: weatherURL, parameters: params)
            getCurrentWeatherData(url: currentWeatherURL, parameters: params)
            getTMData(url: kakaoCoordinateURL, parameters: tmParams)
        }
    }
    
    //현재 날짜에 대한 데이터를 한글로 바꾸기 위해 메소드 설정
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
    
    //MARK: - Button Action
    @IBAction func refreshAction(_ sender: UIButton) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        UIView.animate(withDuration: 0.5) {
            if self.sectionIsExpanded {
                self.refreshBtn.transform = CGAffineTransform.identity
                self.sectionIsExpanded = false
            } else {
                self.refreshBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                self.sectionIsExpanded = true
            }
        }
    }
    
    //MARK: - Networking
    //날씨 API JSON 가져오기
    //현재의 날씨 데이터 가져오기
    func getCurrentWeatherData(url: String, parameters: [String: String]) {
        WeatherDataModel.main.weatherData.removeAll()
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [weak self] response in
            guard let `self` = self else { return }
            if response.result.isSuccess {
                let currentWeatherJSON: JSON = JSON(response.result.value!)
                self.updateCurrentWeatherData(json: currentWeatherJSON)
            }else {
                print("Error \(response.result.error!)")
                self.locationLabel.text = "Connection Issues"
                HUD.flash(HUDContentType.label("잠시후\n다시 시도해주세요"), delay: 1.0)
            }
        }
    }
    
    //일기 예보 정보 가져오기
    func getforecastWeatherData(url: String, parameters: [String: String]) {
        WeatherDataModel.main.weatherData.removeAll()
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [weak self] response in
            guard let `self` = self else { return }
            if response.result.isSuccess {
                let weatherJSON: JSON = JSON(response.result.value!)
                self.updateforecastWeatherData(json: weatherJSON)
            }else {
                print("Error \(response.result.error!)")
                self.locationLabel.text = "Connection Issues"
                HUD.flash(HUDContentType.label("잠시후\n다시 시도해주세요"), delay: 1.0)
            }
        }
    }
    
    //미세먼지 API JSON 가져오기
    func getTMData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters, headers: kakaoHeaders).responseJSON { [weak self] response in
            guard let `self` = self else { return }
            if response.result.isSuccess {
                let data: JSON = JSON(response.result.value!)
                let locationTMx = data["documents"][0]["x"].stringValue
                let locationTMy = data["documents"][0]["y"].stringValue
                let params: [String: String] = ["tmX": locationTMx, "tmY": locationTMy, "pageNo": "1", "numOfRows": "10", "ServiceKey": dustAPIKey, "_returnType": "json"]
                self.getMeasuringStation(url: dustMeasuringStationURL, parameters: params)
            }else {
                print("Error \(response.result.error!)")
                HUD.flash(HUDContentType.label("잠시후\n다시 시도해주세요"), delay: 1.0)
            }
        }
    }
    
    //tmX, tmY로 측정소 이름 가져오기
    func getMeasuringStation(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [weak self] response in
            guard let `self` = self else { return }
            if response.result.isSuccess {
                let data = JSON(response.result.value!)
                let stationName = data["list"][0]["stationName"].stringValue
                let params: [String: String] = ["stationName": stationName, "dataTerm": "MONTH", "pageNo": "1", "numOfRows": "10", "ServiceKey": dustAPIKey, "ver": "1.3", "_returnType": "json"]
                self.getDustData(url: dustDataURL, parameters: params)
            }else {
                print("Error \(response.result.error!)")
                HUD.flash(HUDContentType.label("잠시후\n다시 시도해주세요"), delay: 1.0)
            }
        }
    }
    
    //미세먼지 데이터 가져오기
    func getDustData(url: String, parameters: [String: String]) {
        WeatherDataModel.main.dustData.removeAll()
        WeatherDataModel.main.currentDustData.removeAll()
        WeatherDataModel.main.currentDustGrade.removeAll()
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [weak self] response in
            guard let `self` = self else { return }
            if response.result.isSuccess {
                let datas = JSON(response.result.value!)
                for title in WeatherDataModel.main.dustContent {
                    WeatherDataModel.main.currentDustData.append(datas["list"][0][title].stringValue)
                }
                for title in WeatherDataModel.main.dustGrade {
                    WeatherDataModel.main.currentDustGrade.append(datas["list"][0][title].stringValue)
                }
                WeatherDataModel.main.currentDustDataCount = WeatherDataModel.main.currentDustData.count
                for data in datas["list"] {
                    guard let dustData = DustModel(json: data) else { return }
                    WeatherDataModel.main.dustData.append(dustData)
                }
                self.dustLabel.text = WeatherDataModel.main.changeDustGrade(grade: WeatherDataModel.main.dustData[0].khaiGrade)
                self.dustIcon.image = UIImage(named: WeatherDataModel.main.changedustIcon(grade: WeatherDataModel.main.dustData[0].khaiGrade))
                self.weatherCollectionView.reloadData()
            }else {
                print("Error \(response.result.error!)")
                HUD.flash(HUDContentType.label("잠시후\n다시 시도해주세요"), delay: 1.0)
            }
        }
    }
    //미세먼지 예보 정보를 받음. 세부 정보는 아니고 대한민국의 전국적인 예보를 받아옴
    func getforecastDustData(url: String, parameters: [String: String]) {
        WeatherDataModel.main.forecastDustDate.removeAll()
        WeatherDataModel.main.forecastDustInformCause.removeAll()
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                let datas = JSON(response.result.value!)
                for data in 0...1 {
                    WeatherDataModel.main.forecastDustDate.append(datas["list"][data]["informData"].stringValue)
                    WeatherDataModel.main.forecastDustInformCause.append(datas["list"][data]["informCause"].stringValue)
                    WeatherDataModel.main.forecastDustInformOverall.append(datas["list"][data]["informOverall"].stringValue)
                }
                self.weatherCollectionView.reloadData()
            }else {
                print(response.result.error!)
                HUD.flash(HUDContentType.label("잠시후\n다시 시도해주세요"), delay: 1.0)
            }
        }
    }
    
    //MARK: - JSON Parsing
    //현재 날씨 정보 JSON Parsing
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
    
    //일기 예보 JSON Parsing
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
            HUD.flash(HUDContentType.label("잠시후\n다시 시도해주세요"), delay: 1.0)
        }
    }

    //MARK: - UI Updates
    func updateUIWithWeatherDate() {
        //locationLabel.text = WeatherDataModel.main.city
        tempLabel.text = String(WeatherDataModel.main.temperature) + "˚"
        maxTempLabel.text = String(WeatherDataModel.main.maxTemperature) + "˚"
        minTempLabel.text = String(WeatherDataModel.main.minTemperature) + "˚"
        weatherInfo.text = WeatherDataModel.main.changeKRWeatherCondition(condition: WeatherDataModel.main.weatherIconName)
        var weatherIconName = WeatherDataModel.main.weatherIconName
        formatter.dateFormat = "HH"
        let meridian = Int(formatter.string(from: Date()))
        
        if meridian! >= 18 || meridian! <= 3 {
            weatherIconName = "Night" + weatherIconName
        }
        weatherIcon.image = UIImage(named: weatherIconName)
    }
    
    //한국 주소를 받는 메소드 (..구 ..동)
    func getLocationData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters, headers: kakaoHeaders).responseJSON { response in
            if response.result.isSuccess {
                let data: JSON = JSON(response.result.value!)
                self.locationLabel.text = data["documents"][0]["region_2depth_name"].stringValue + " " + data["documents"][0]["region_3depth_name"].stringValue
            }else {
                print("error")
                HUD.flash(HUDContentType.label("잠시후\n다시 시도해주세요"), delay: 1.0)
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
            
            let param: [String: String] = ["lat": latitude, "lon": longitude, "appid": weatherAPIKey]
            let locationParams: [String: String] = ["y": latitude, "x": longitude, "input_coord": "WGS84", "output_coord": "WCONGNAMUL"]
            let tmParams: [String: String] = ["y": latitude, "x": longitude, "input_coord": "WGS84", "output_coord": "WTM"]
            
            formatter.dateFormat = "HH"
            let hour: Int = Int(formatter.string(from: Date()))!
            var currentdate: String = ""
            if hour >= 5 {
                formatter.dateFormat = "yyyy-MM-dd"
                currentdate = formatter.string(from: Date())
            }else {
                formatter.dateFormat = "yyyy-MM-dd"
                currentdate = formatter.string(from: Date(timeIntervalSinceNow: -86400))
            }
            
            let forecastDust: [String: String] = ["searchDate": currentdate, "ServiceKey": dustAPIKey, "_returnType": "json"]
            
            getforecastDustData(url: forecastDustURL, parameters: forecastDust)
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
        //위치 접근 허용이 안되어 있는 경우 알럿으로 이동할 수 있게 함
        UIAlertController.presentAlertController(target: self, title: "위치 접근 허용", massage: "위치 접근 허용이 되어 있지 않습니다. 위치 접근 허용하려면 세팅에서 앱에 들어가 접근을 하용해야 합니다. 이동하시겠습니까? ", cancelBtn: true) { (action) in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

//MARK: - extension
//UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 1 {
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "cellB", for: indexPath) as! CellB
            cellB.cellCount = WeatherDataModel.main.currentDustDataCount
            if WeatherDataModel.main.currentDustDataCount == WeatherDataModel.main.oldCurrentDustDataCount {
                cellB.dustTableView.reloadData()
            }
            return cellB
        } else {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "cellA", for: indexPath) as! CellA
            cellA.cellCount = WeatherDataModel.main.forecastCount
            if WeatherDataModel.main.forecastCount == WeatherDataModel.main.preforecastCount {
                cellA.forecastCollectionView.reloadData()
            }
            return cellA
        }
    }
}

//MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 1 {
            return CGSize(width: self.view.frame.width, height: (self.weatherCollectionView.frame.maxY - weatherCollectionView.frame.minY - 100 - 2))
        }else {
            return CGSize(width: self.view.frame.width, height: 100)
        }
    }
}

//UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    
}
