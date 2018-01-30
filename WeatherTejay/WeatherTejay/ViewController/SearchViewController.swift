
import UIKit
import SwiftyJSON
import Alamofire

class SearchViewController: UIViewController, UISearchBarDelegate {

    var totalAddresses: [String] = []
    var currentAddresses: [String] = []
    var previousAddresses: [String] = []
    var dataTime: String = ""
    var mangName: String = ""
    var so2Value: String = ""
    var coValue: String = ""
    var o3Value: String = ""
    var no2Value: String = ""
    var pm10Value: String = ""
    var pm10Value24: String = ""
    var pm25Value: String = ""
    var pm25Value24: String = ""
    var khaiValue: String = ""
    var khaiGrade: String = ""
    var so2Grade: String = ""
    var coGrade: String = ""
    var o3Grade: String = ""
    var no2Grade: String = ""
    var pm10Grade: String = ""
    var pm25Grade: String = ""
    var pm10Grade1h: String = ""
    var pm25Grade1h: String = ""

    
    
    @IBOutlet weak var addressTablewView: UITableView!
    @IBOutlet weak var addressSearchbar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSerachBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            
            if let path = Bundle.main.path(forResource: "Addresses", ofType: "json"),
                let contents = try? String(contentsOfFile: path),
                let data = contents.data(using: .utf8) {
                if let addressesJSON: JSON = try? JSON(data: data) {
                    //print("addressesJSON", addressesJSON)
                    for address in addressesJSON["addresses"] {
                        self.totalAddresses.append(String(describing: address.1))
                        self.currentAddresses.append(String(describing: address.1))
                    }
                    //print(self.totalAddresses)
                }
                print(self.totalAddresses.count)
                //self.currentAddresses = self.totalAddresses
            }
        }
    }
    
    private func setupSerachBar() {
        addressSearchbar.delegate = self
        addressSearchbar.placeholder = "주소를 검색해주세요."
        //addressSearchbar.changeSearchBarColor(color: .black)
        addressSearchbar.barTintColor = .white
        navigationItem.titleView = addressSearchbar

    }
    
    //MARK: - SearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentAddresses = totalAddresses
            addressTablewView.reloadData()
            return }
        currentAddresses = totalAddresses.filter({ string -> Bool in
            return string.contains(searchText)
        })
        addressTablewView.reloadData()
    }
    
    //MARK: - NETWORK
    //행정구역의 경도 위도 가져오기
    func getCoordinateData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters, headers: kakaoHeaders).responseJSON { [weak self] response in
            guard let `self` = self else { return }
            if response.result.isSuccess {
                let data: JSON = JSON(response.result.value!)
                let locationX = data["documents"][0]["x"].stringValue
                let locationY = data["documents"][0]["y"].stringValue
                let params: [String: String] = ["x": locationX, "y": locationY, "input_coord": "WGS84", "output_coord": "TM"]
                self.changeCoordinate(url: kakaoCoordinateURL, parameters: params)
            }else {
                print("Error \(response.result.error!)")
            }
        }
    }
    
    //경도 위도를 tmX, tmY좌표로 변환하기
    func changeCoordinate(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters, headers: kakaoHeaders).responseJSON { [weak self] response in
            guard let `self` = self else { return }
            if response.result.isSuccess {
                let data: JSON = JSON(response.result.value!)
                let locationTMx = data["documents"][0]["x"].stringValue
                let locationTMy = data["documents"][0]["y"].stringValue
                let params: [String: String] = ["tmX": locationTMx, "tmY": locationTMy, "pageNo": "1", "numOfRows": "10", "ServiceKey": dustAPIKey, "_returnType": "json"]
                self.getMeasuringStation(url: dustMeasuringStationURL, parameters: params)
            }else {
                print("Error \(response.result.error!)")
            }
        }
    }
    
    //tmX, tmY로 측정소 이름 가져오기
    func getMeasuringStation(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [weak self] response in
            guard let `self` = self else { return }
            if response.result.isSuccess {
                let data = JSON(response.result.value!)
                let stationName = data["list"][0]["stationName"].stringValue
                let params: [String: String] = ["stationName": stationName, "dataTerm": "month", "pageNo": "1", "numOfRows": "10", "ServiceKey": dustAPIKey, "ver": "1.3", "_returnType": "json"]
                self.getDustData(url: dustDataURL, parameters: params)
                print(stationName)
            }else {
                print("Error \(response.result.error!)")
            }
        }
    }
    
    func getDustData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                let data = JSON(response.result.value!)
                print(data)
            }else {
            }
        }
    }
    
    @IBAction func dismissBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if previousAddresses.count == 0 {
            return currentAddresses.count
        }
        return previousAddresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = currentAddresses[indexPath.row]
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //셀을 눌렀을 때의 값을 이용하여 주소값 가져오기
        let name = currentAddresses[indexPath.row]
        let parameters: [String: String] = ["query": name]
        getCoordinateData(url: kakaoSearchAddressURL, parameters: parameters)
    }
}

