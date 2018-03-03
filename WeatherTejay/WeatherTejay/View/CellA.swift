
import UIKit

class CellA: UICollectionViewCell {
    
    //MARK: - Variable
    var cellCount: Int = 0 {
        didSet {
            if oldValue != cellCount {
                forecastCollectionView.reloadData()
            }
        }
    }
    
    var seperatorView: UIView = {
        var seperatorView = UIView()
        seperatorView.backgroundColor = .black
        return seperatorView
    }()
    
    let formatter = DateFormatter()
    let mainViewController = MainViewController()
    
    //MARK: - IBOutlet
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//MARK: - Extension
//UICollectionViewDataSource\
extension CellA: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WeatherDataModel.main.weatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCellA = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCellA", for: indexPath) as! ItemCellA
//        formatter.dateFormat = "d일 HH시"
        
        itemCellA.forecastDate.text = WeatherDataModel.main.weatherData[indexPath.row]["date"]
        itemCellA.forecastImgView.image = UIImage(named: WeatherDataModel.main.changeWeatherCondition(condition: WeatherDataModel.main.weatherData[indexPath.row]["condition"]!))
        let tempString = WeatherDataModel.main.weatherData[indexPath.row]["temperature"]?.replace(target: ".00", withString: "")
        itemCellA.forecastTempLabel.text = tempString! + " ˚"
        
        return itemCellA
    }
}

//UICollectionViewDelegate
extension CellA: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 5, height: self.frame.height)
    }
}

//UICollectionViewDelegateFlowLayout
extension CellA: UICollectionViewDelegateFlowLayout {
    
}
