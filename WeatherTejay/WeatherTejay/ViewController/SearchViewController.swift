
import UIKit
import SwiftyJSON
import Alamofire

class SearchViewController: UIViewController, UISearchBarDelegate {

    var totalAddresses: [String] = []
    var currentAddresses: [String] = []
    var previousAddresses: [String] = []
    var address: String = ""
    
    @IBOutlet weak var addressTablewView: UITableView!
    @IBOutlet weak var addressSearchbar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSerachBar()
        
        //노티센터를 통해 키보드가 올라오고 내려갈 경우 실행할 함수 설정
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        WeatherDataModel.main.weatherLocationX = ""
        WeatherDataModel.main.weatherLocationY = ""
        setupSerachBar()
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            
            if let path = Bundle.main.path(forResource: "Addresses", ofType: "json"),
                let contents = try? String(contentsOfFile: path),
                let data = contents.data(using: .utf8) {
                if let addressesJSON: JSON = try? JSON(data: data) {
                    //print("addressesJSON", addressesJSON)
                    for address in addressesJSON["addresses"] {
                        self.totalAddresses.append(address.1.stringValue)
                        self.currentAddresses.append(address.1.stringValue)
                    }
                }
                self.currentAddresses = self.totalAddresses
                DispatchQueue.main.async {
                    self.addressTablewView.reloadData()
                }
                
            }
        }
    }
    
    //MARK: - 키보드가 올라올 경우 키보드의 높이 만큼 스크롤 뷰의 크기를 줄여줌
    @objc func keyboardDidShow(_ noti: Notification) {
        guard let info = noti.userInfo else { return }
        guard let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        addressTablewView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
    }
    
    //MARK: - 키보드가 내려갈 경우 원래의 크기대로 돌림
    @objc func keyboardWillHide(_ noti: Notification) {
        addressTablewView.contentInset = UIEdgeInsets.zero
    }
    
    private func setupSerachBar() {
        addressSearchbar.delegate = self
        addressSearchbar.placeholder = "주소를 검색해주세요."
        //addressSearchbar.changeSearchBarColor(color: .black)
        addressSearchbar.barTintColor = UIColor(red: 199.0/255.0, green: 234.0/255.0, blue: 70.0/255.0, alpha: 1.0)
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
                WeatherDataModel.main.address = data["documents"][0]["address"]["region_2depth_name"].stringValue + " " +  data["documents"][0]["address"]["region_3depth_h_name"].stringValue
                WeatherDataModel.main.weatherLocationX = data["documents"][0]["x"].stringValue
                WeatherDataModel.main.weatherLocationY = data["documents"][0]["y"].stringValue
                let params: [String: String] = ["x": WeatherDataModel.main.weatherLocationX, "y": WeatherDataModel.main.weatherLocationY, "input_coord": "WGS84", "output_coord": "WTM"]
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
            print(response.request)
            guard let `self` = self else { return }
            if response.result.isSuccess {
                let data = JSON(response.result.value!)
                let stationName = data["list"][0]["stationName"].stringValue
                let params: [String: String] = ["stationName": stationName, "dataTerm": "MONTH", "pageNo": "1", "numOfRows": "10", "ServiceKey": dustAPIKey, "ver": "1.3", "_returnType": "json"]
                self.getDustData(url: dustDataURL, parameters: params)
            }else {
                print("Error \(response.result.error!)")
            }
        }
    }
    
    //미세먼지 데이터 가져오기
    func getDustData(url: String, parameters: [String: String]) {
        WeatherDataModel.main.dustData.removeAll()
        WeatherDataModel.main.currentDustData.removeAll()
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                print(response.request)
                let datas = JSON(response.result.value!)
                for title in WeatherDataModel.main.dustContent {
                    WeatherDataModel.main.currentDustData.append(datas["list"][0][title].stringValue)
                }
                for title in WeatherDataModel.main.dustGrade {
                    WeatherDataModel.main.currentDustGrade.append(datas["list"][0][title].stringValue)
                }
                print(WeatherDataModel.main.currentDustData.count)
                WeatherDataModel.main.currentDustDataCount = WeatherDataModel.main.currentDustData.count
                for data in datas["list"] {
                    guard let dustData = DustModel(json: data) else { return }
                    WeatherDataModel.main.dustData.append(dustData)
                }
            }else {
                print("Error \(response.result.error!)")
            }
            self.dismiss(animated: true, completion: nil)
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

