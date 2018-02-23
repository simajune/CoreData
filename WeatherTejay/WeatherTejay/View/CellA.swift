
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
        formatter.dateFormat = "d일 HH시"
        
        itemCellA.forecastDate.text = formatter.string(from: WeatherDataModel.main.weatherData[indexPath.row].date!)
        itemCellA.forecastImgView.image = UIImage(named: WeatherDataModel.main.updateWeatherIcon(condition: WeatherDataModel.main.weatherData[indexPath.row].condition!))
        itemCellA.forecastTempLabel.text = "\(WeatherDataModel.main.weatherData[indexPath.row].temp!)" + " ˚"
        
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
