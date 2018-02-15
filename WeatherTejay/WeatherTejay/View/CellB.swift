
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
    }
    
}

//MARK: - UITableViewDataSource
extension CellB: UITableViewDataSource {
    //테이블 뷰 섹션의 셀 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            //print(WeatherDataModel.main.currentDustDataCount)
            return WeatherDataModel.main.currentDustData.count
        }
        return 2
    }
    //테이블 뷰 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCellB", for: indexPath) as! ItemCellB
            cell.label.text = WeatherDataModel.main.dustName[indexPath.row]
            //print(WeatherDataModel.main.currentDustData)
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
//MARK: - UITableViewDelegate
extension CellB: UITableViewDelegate {
    //테이블 뷰 섹션의 갯수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    //테이블 뷰 헤더의 백그라운드 컬러, 포트 설정
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.font = UIFont(name: "Yanolja Yache OTF", size: 17)
            headerTitle.contentView.backgroundColor = UIColor(red:0.55, green:0.69, blue:1.00, alpha:1.00)
        }
    }
    //테이블 뷰 섹션의 타이틀 설정
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "미세먼지 세부정보"
        }
        return "오늘의 미세먼지 정보"
    }
    //테이블뷰 섹션의 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}

