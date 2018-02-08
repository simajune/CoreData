
import UIKit

class CellA: UICollectionViewCell, MainDelegate {
    
    //MARK: - Variable
    var cellCount: Int = 0 {
        didSet {
            if oldValue != cellCount {
                forecastCollectionView.reloadData()
            }
        }
    }
    let formatter = DateFormatter()
    let mainViewController = MainViewController()
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainViewController.delegate = self
    }
    
    func updateCell(count: Int) {
        print("Hi")
        cellCount = count
        forecastCollectionView.reloadData()
    }

}

extension CellA: UICollectionViewDelegateFlowLayout {
    
}

extension CellA: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WeatherDataModel.main.weatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCellA = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCellA", for: indexPath) as! ItemCellA
//        print(WeatherDataModel.main.weatherDate)
        formatter.dateFormat = "d일 HH시"
        
        //에러 확인 필요
        itemCellA.forecastDate.text = formatter.string(from: WeatherDataModel.main.weatherData[indexPath.row].date!)
        itemCellA.forecastImgView.image = UIImage(named: WeatherDataModel.main.updateWeatherIcon(condition: WeatherDataModel.main.weatherData[indexPath.row].condition!))
        itemCellA.forecastTempLabel.text = "\(WeatherDataModel.main.weatherData[indexPath.row].temp!)" + " ˚"
        
        return itemCellA
    }
}

extension CellA: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 5, height: self.frame.height)
    }
}
