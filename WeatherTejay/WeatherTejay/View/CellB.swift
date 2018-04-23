
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
    
    var forecastCellCount: Int = 0 {
        didSet {
            if oldValue != forecastCellCount {
                dustTableView.reloadData()
            }
        }
    }
    
    var dataModel: DataModel!
    
    @IBOutlet weak var dustTableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        dataModel = DataModel()
    }
}

//MARK: - UITableViewDataSource
extension CellB: UITableViewDataSource {
    //테이블 뷰 섹션의 셀 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return dataModel.currentDustData.count
        }else {
            print(dataModel.forecastDustInformOverall.count)
            return dataModel.forecastDustInformOverall.count
        }
    }
    //테이블 뷰 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCellB", for: indexPath) as! ItemCellB
            cell.unitLabel.isHidden = false
            cell.gradeLabel.isHidden = false
            cell.dustValueLabel.isHidden = false
            cell.forecastDustLabel.isHidden = true
            cell.label.text = dataModel.dustName[indexPath.row]
            cell.dustValueLabel.text = dataModel.currentDustData[indexPath.row]
            cell.gradeLabel.text = dataModel.changeDustGrade(grade: dataModel.currentDustGrade[indexPath.row])
            
            if indexPath.row == 0 || indexPath.row == 1 {
                cell.unitLabel.text = "㎍/㎥"
            }else {
                cell.unitLabel.text = "ppm"
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCellB", for: indexPath) as! ItemCellB
            cell.unitLabel.isHidden = true
            cell.gradeLabel.isHidden = true
            cell.dustValueLabel.isHidden = true
            cell.forecastDustLabel.isHidden = false
            print("forecastDustDate", dataModel.forecastDustDate)
            cell.label.text = dataModel.forecastDustDate[indexPath.row]
            cell.forecastDustLabel.font = UIFont(name: "Yanolja Yache OTF", size: 12)
            print("forecastDustInformOverall", dataModel.forecastDustInformOverall)
            cell.forecastDustLabel.text = dataModel.forecastDustInformOverall[indexPath.row]
            cell.forecastDustLabel.text = cell.forecastDustLabel.text?.replace(target: "○ [미세먼지]", withString: "")
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 55
        }
        return 40
    }
    
    //테이블 뷰 섹션의 타이틀 설정
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "미세먼지 정보"
        }
        return "미세먼지 예보"
    }
    
    //테이블뷰 섹션의 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}

