
import UIKit

class CellB: UICollectionViewCell {
    //MARK: - Variable
    var cellCount: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awake")
        
    }
    
}

extension CellB: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count")
        return WeatherDataModel.main.dustContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCellB", for: indexPath) as! ItemCellB
        cell.label.text = WeatherDataModel.main.dustName[indexPath.row]
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

