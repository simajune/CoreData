
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
    
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationLabel.text = WeatherDataModel.main.address
        if WeatherDataModel.main.weatherLocationX != "" && WeatherDataModel.main.weatherLocationX != "" {
            let params: [String: String] = ["lat": WeatherDataModel.main.weatherLocationY, "lon": WeatherDataModel.main.weatherLocationX, "appid": weatherAPIKey]
            let tmParams: [String: String] = ["y": WeatherDataModel.main.weatherLocationY, "x": WeatherDataModel.main.weatherLocationX, "input_coord": "WGS84", "output_coord": "TM"]
            getWeatherData(url: weatherURL, parameters: params)
            getTMData(url: kakaoCoordinateURL, parameters: tmParams)
        }
    }
    
    //MARK: - Btn Add Ta
    
    //MARK: - Networking
    //날씨 API JSON 가져오기
    func getWeatherData(url: String, parameters: [String: String]) {
        WeatherDataModel.main.weatherData.removeAll()
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                print("Success! Got the weather data")
                let weatherJSON: JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                
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
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                let datas = JSON(response.result.value!)
                for title in WeatherDataModel.main.dustContent {
                    WeatherDataModel.main.currentDustData.append(datas["list"][0][title].stringValue)
                }
                for title in WeatherDataModel.main.dustGrade {
                    WeatherDataModel.main.currentDustGrade.append(datas["list"][0][title].stringValue)
                }
                WeatherDataModel.main.currentDustDataCount = WeatherDataModel.main.currentDustData.count
                self.dustLabel.text = WeatherDataModel.main.changeDustGrade(grade: WeatherDataModel.main.currentDustGrade[0])
                for data in datas["list"] {
                    guard let dustData = DustModel(json: data) else { return }
                    WeatherDataModel.main.dustData.append(dustData)
                }
            }else {
                print("Error \(response.result.error!)")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK: - JSON Parsing
    func updateWeatherData(json: JSON) {
        if let tempResult = json["list"][0]["main"]["temp"].double {
            WeatherDataModel.main.temperature = Int(tempResult - 273.15)
            WeatherDataModel.main.condition = json["list"][0]["weather"][0]["id"].intValue
            WeatherDataModel.main.weatherIconName = WeatherDataModel.main.updateWeatherIcon(condition: WeatherDataModel.main.condition)
            for index in json["list"] {
                guard let weatherData = WeatherModel(json: index) else { return }
                WeatherDataModel.main.weatherData.append(weatherData)
            }
            //print(WeatherDataModel.main.weatherData)
            WeatherDataModel.main.forecastCount = json["list"].count - 1
            
//            print(WeatherDataModel.main.forecastCount)
            delegate?.updateCell(count: WeatherDataModel.main.forecastCount)
            
            
            weatherCollectionView.reloadData()
            updateUIWithWeatherDate()
        }else {
            locationLabel.text = "Weather Unavailable"
        }
    }
    
    
    //MARK: - UI Updates
    func updateUIWithWeatherDate() {
        //locationLabel.text = WeatherDataModel.main.city
        tempLabel.text = String(WeatherDataModel.main.temperature)
        weatherIcon.image = UIImage(named: WeatherDataModel.main.weatherIconName)
    }
    
    func getLocationData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters, headers: kakaoHeaders).responseJSON { response in
            if response.result.isSuccess {
                let data: JSON = JSON(response.result.value!)
                print(response.request)
                print(data)
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
            
            print("long = \(location.coordinate.longitude), lat = \(location.coordinate.latitude)")
            
            let longitude = String(location.coordinate.longitude)
            let latitude = String(location.coordinate.latitude)
            print("long", longitude)
            print("lat", latitude)
            
            let param: [String: String] = ["lat": latitude, "lon": longitude, "appid": weatherAPIKey]
            let locationParams: [String: String] = ["y": latitude, "x": longitude, "input_coord": "WGS84", "output_coord": "CONGNAMUL"]
            let tmParams: [String: String] = ["y": latitude, "x": longitude, "input_coord": "WGS84", "output_coord": "TM"]
            getTMData(url: kakaoCoordinateURL, parameters: tmParams)
            getWeatherData(url: weatherURL, parameters: param)
            getLocationData(url: kakaoGetAddressURL, parameters: locationParams)
            
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
            print("cellACount: ", cellA.cellCount)
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
