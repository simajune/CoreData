
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
//        dustTableView.headerView(forSection: 0)?.backgroundColor = .white
    }
    
}

extension CellB: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            print(WeatherDataModel.main.currentDustDataCount)
            return WeatherDataModel.main.currentDustData.count
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCellB", for: indexPath) as! ItemCellB
            cell.label.text = WeatherDataModel.main.dustName[indexPath.row]
            print(WeatherDataModel.main.currentDustData)
            cell.dustValueLabel.text = WeatherDataModel.main.currentDustData[indexPath.row]
            cell.gradeLabel.text = WeatherDataModel.main.changeDustGrade(grade: WeatherDataModel.main.currentDustGrade[indexPath.row])
            
            if indexPath.row == 0 || indexPath.row == 1 {
                cell.unitLabel.text = "㎍/㎥"
            }else {
                cell.unitLabel.text = "ppm"
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCellB", for: indexPath) as! ItemCellB
            return cell
        }
        
    }
}

extension CellB: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.font = UIFont(name: "Yanolja Yache OTF", size: 17)
            headerTitle.contentView.backgroundColor = UIColor(red: 250.0/255/0, green: 239.0/255.0, blue: 75.0/255.0, alpha: 1.0)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "미세먼지 세부정보"
        }
        return "오늘의 미세먼지 정보"
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}

