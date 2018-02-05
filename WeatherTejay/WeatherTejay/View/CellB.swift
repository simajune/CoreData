
import UIKit

class CellB: UICollectionViewCell {
    //MARK: - Variable
    var cellCount: Int = 0 {
        didSet {
            if oldValue != cellCount {
                dustTableView.reloadData()
            }
        }
    }
    @IBOutlet weak var dustTableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awake")
        
    }
    
}

extension CellB: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeatherDataModel.main.currentDustData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCellB", for: indexPath) as! ItemCellB
        cell.label.text = WeatherDataModel.main.dustName[indexPath.row]
        cell.dustValueLabel.text = WeatherDataModel.main.currentDustData[indexPath.row]
        cell.gradeLabel.text = WeatherDataModel.main.changeDustGrade(grade: WeatherDataModel.main.currentDustGrade[indexPath.row])
        
        if indexPath.row == 0 || indexPath.row == 1 {
            cell.unitLabel.text = "㎍/㎥"
        }else {
            cell.unitLabel.text = "ppm"
        }
        return cell
    }
}

extension CellB: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "안녕하세요"
    }
}

