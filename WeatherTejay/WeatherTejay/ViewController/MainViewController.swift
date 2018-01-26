
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
    let weatherDataModel = WeatherDataModel()
    let formatter = DateFormatter()
    
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
        
        
    }
    //MARK: - Networking
    func getWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                print("Success! Got the weather data")
                let weatherJSON: JSON = JSON(response.result.value!)
                //print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
                
            }else {
                print("Error \(response.result.error!)")
                self.locationLabel.text = "Connection Issues"
            }
        }
    }
    
    //MARK: - JSON Parsing
    func updateWeatherData(json: JSON) {
//        print(json)
        if let tempResult = json["list"][0]["main"]["temp"].double {
            
            WeatherDataModel.main.temperature = Int(tempResult - 273.15)
            WeatherDataModel.main.city = json["city"]["name"].stringValue
            WeatherDataModel.main.condition = json["list"][0]["weather"][0]["id"].intValue
            for index in json["list"] {
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = formatter.date(from: index.1["dt_txt"].stringValue)
                WeatherDataModel.main.weatherDate.append(date!)
            }
            WeatherDataModel.main.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            WeatherDataModel.main.forecastCount = json["list"].count - 1
            
//            print(WeatherDataModel.main.forecastCount)
            delegate?.updateCell(count: weatherDataModel.forecastCount)
            weatherCollectionView.reloadData()
            updateUIWithWeatherDate()
            
        }else {
            locationLabel.text = "Weather Unavailable"
        }
    }
    
    //MARK: - UI Updates
    func updateUIWithWeatherDate() {
        locationLabel.text = WeatherDataModel.main.city
        tempLabel.text = String(WeatherDataModel.main.temperature)
        weatherIcon.image = UIImage(named: WeatherDataModel.main.weatherIconName)
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
            
            let param: [String: String] = ["lat": latitude, "lon": longitude, "appid": weatherAPIKey]
            getWeatherData(url: weatherURL, parameters: param)
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
            return cellB
        } else {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "cellA", for: indexPath) as! CellA
            cellA.cellCount = WeatherDataModel.main.forecastCount
            print("cellACount: ", cellA.cellCount)
            return cellA
        }
    }
    
    
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 1 {
            return CGSize(width: self.view.frame.width, height: 500)
        }else {
            return CGSize(width: self.view.frame.width, height: 100)
        }
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
}
