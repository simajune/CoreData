
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
                print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
                
            }else {
                print("Error \(response.result.error!)")
                self.locationLabel.text = "Connection Issues"
            }
        }
    }
    
    //MARK: - JSON Parsing
    func updateWeatherData(json: JSON) {
        if let tempResult = json["list"][0]["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["city"]["name"].stringValue
            weatherDataModel.condition = json["list"][0]["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            weatherDataModel.forecastCount = json["list"].count
            print(weatherDataModel.forecastCount)
            delegate?.updateCell(count: weatherDataModel.forecastCount)
            weatherCollectionView.reloadData()
            updateUIWithWeatherDate()
            
        }else {
            locationLabel.text = "Weather Unavailable"
        }
    }
    
    //MARK: - UI Updates
    func updateUIWithWeatherDate() {
        locationLabel.text = weatherDataModel.city
        tempLabel.text = String(weatherDataModel.temperature)
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
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
            cellA.cellCount = weatherDataModel.forecastCount
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
