
import UIKit
import CoreData
import SwiftyJSON
import Alamofire
import PKHUD

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    //MARK: - Variable
    var totalAddresses: [String] = []
    var currentAddresses: [String] = []
    var previousAddresses: [NSManagedObject] = []
    var previousStringAddress: [String] = []
    var managedObjectContext: NSManagedObjectContext?
    var address: String = ""
    var stationList: [String] = []
    var dustParams: [String: String] = [:]
    var changeDustNum: Int = 0
    
    //MARK: - IBOutlet
    @IBOutlet weak var addressTablewView: UITableView!
    @IBOutlet weak var addressSearchbar: UISearchBar!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSerachBar()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        loadData()
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
                        //self.currentAddresses.append(address.1.stringValue)
                    }
                }
                if self.previousStringAddress.count != 0 {
                    self.currentAddresses = self.previousStringAddress
                }else {
                    self.currentAddresses = self.totalAddresses
                }
                DispatchQueue.main.async {
                    self.addressTablewView.reloadData()
                }
                
            }
        }
    }
    
    //PM10데이터 값에 따른 등급을 WHO기준으로 변환
    private func changeWHOPM10Grade(value: String) -> String {
        if value == "-" {
            return "5"
        }
        let intValue = Int(value)!
        switch intValue {
        case 0...30:
            return "1"
        case 31...50:
            return "2"
        case 51...100:
            return "3"
        default:
            return "4"
        }
    }
    
    //PM2.5데이터 값에 따른 등급을 WHO기준으로 변환
    private func changeWHOPM25Grade(value: String) -> String {
        if value == "-" {
            return "5"
        }
        let intValue = Int(value)!
        switch intValue {
        case 0...15:
            return "1"
        case 16...25:
            return "2"
        case 26...50:
            return "3"
        default:
            return "4"
        }
    }
    
    //CoreData에 저장된 데이터 Fetch
    func loadData() {
        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Towns")
        
        do {
            let result = try managedObjectContext?.fetch(request)
            previousAddresses = result!
            previousAddresses.reverse()
            previousStringAddress = []
            for town in previousAddresses {
                let stringTown = town.value(forKey: "town") as! String
                previousStringAddress.append(stringTown)
            }
            addressTablewView.reloadData()
        }
        catch {
            fatalError("Error in retrieving Grocery item")
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
    
    @IBAction func dismissBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //SearchBar의 기본 설정
    private func setupSerachBar() {
        addressSearchbar.delegate = self
        addressSearchbar.placeholder = "주소를 검색해주세요."
        //addressSearchbar.changeSearchBarColor(color: .black)
        addressSearchbar.barTintColor = UIColor(red:0.55, green:0.69, blue:1.00, alpha:1.00)
        navigationItem.titleView = addressSearchbar

    }
    
    //MARK: - SearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            if previousAddresses.count != 0 {
                previousStringAddress = []
                for town in previousAddresses {
                    let stringTown = town.value(forKey: "town") as! String
                    previousStringAddress.append(stringTown)
                }
                currentAddresses = previousStringAddress
            }else {
                currentAddresses = totalAddresses
            }
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
                //주소 값 중에 안 맞는 부분이 있어서 조건문으로 저장
                if data["documents"][0]["address"]["region_3depth_h_name"].stringValue == "" {
                    WeatherDataModel.main.address = data["documents"][0]["address"]["region_2depth_name"].stringValue + " " +  data["documents"][0]["address"]["region_3depth_name"].stringValue
                }else {
                    WeatherDataModel.main.address = data["documents"][0]["address"]["region_2depth_name"].stringValue + " " +  data["documents"][0]["address"]["region_3depth_h_name"].stringValue
                }
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
            guard let `self` = self else { return }
            if response.result.isSuccess {
                let data = JSON(response.result.value!)
                //변수값 초기화
                self.stationList.removeAll()
                self.changeDustNum = 0
                //현재 위치에서 거리순으로 가까운 측정소 3곳을 저장
                for list in data["list"] {
                    self.stationList.append(list.1["stationName"].stringValue)
                }
                
                self.dustParams = ["stationName": self.stationList[self.changeDustNum], "dataTerm": "MONTH", "pageNo": "1", "numOfRows": "10", "ServiceKey": dustAPIKey, "ver": "1.3", "_returnType": "json"]
                self.getDustData(url: dustDataURL, parameters: self.dustParams)
            }else {
                print("Error \(response.result.error!)")
                dustAPIKey = originalAPIKey
                HUD.flash(HUDContentType.label("측정소 정보를 받아올 수 없습니다.\n잠시후 다시 시도해주세요"), delay: 1.0)
            }
        }
    }
    
    //미세먼지 데이터 가져오기
    func getDustData(url: String, parameters: [String: String]) {
        WeatherDataModel.main.dustData.removeAll()
        WeatherDataModel.main.currentDustData.removeAll()
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [weak self] response in
            guard let `self` = self else { return }
            if response.result.isSuccess {
                let datas = JSON(response.result.value!)
                //만약 측정소의 문제로 인해 미세먼지의 값이 나오지 않을 경우 근처의 다른 측정소의 정보를 가져옴
                if datas["list"][0]["pm10Value"].stringValue == "-" && datas["list"][0]["pm25Value"].stringValue == "-" && datas["list"][0]["khaiValue"].stringValue == "-" {
                    if self.changeDustNum < 2 {
                        self.changeDustNum += 1
                        self.dustParams = ["stationName": self.stationList[self.changeDustNum], "dataTerm": "MONTH", "pageNo": "1", "numOfRows": "10", "ServiceKey": dustAPIKey, "ver": "1.3", "_returnType": "json"]
                        self.getDustData(url: dustDataURL, parameters: self.dustParams)
                    }
                    else {
                        HUD.flash(HUDContentType.label("미세먼지 정보를 받아올 수 없습니다\n잠시후 다시 시도해주세요"), delay: 1.0)
                    }
                }else {
                    for title in WeatherDataModel.main.dustContent {
                        WeatherDataModel.main.currentDustData.append(datas["list"][0][title].stringValue)
                    }
                    WeatherDataModel.main.currentDustGrade.append(self.changeWHOPM10Grade(value: datas["list"][0]["pm10Value"].stringValue))
                    WeatherDataModel.main.currentDustGrade.append(self.changeWHOPM25Grade(value: datas["list"][0]["pm25Value"].stringValue))
                    for title in WeatherDataModel.main.dustGrade {
                        WeatherDataModel.main.currentDustGrade.append(datas["list"][0][title].stringValue)
                    }
                    WeatherDataModel.main.currentDustDataCount = WeatherDataModel.main.currentDustData.count
                    for data in datas["list"] {
                        guard let dustData = DustModel(json: data) else { return }
                        WeatherDataModel.main.dustData.append(dustData)
                    }
                }
            }else {
                print("Error \(response.result.error!)")
                dustAPIKey = originalAPIKey
                HUD.flash(HUDContentType.label("미세먼지 정보를 받아올 수 없습니다\n잠시후 다시 시도해주세요"), delay: 1.0)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    func saveTown(name: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //검색의 갯수는 5개로 지정
        if previousAddresses.count > 5 {
            let removeData = previousAddresses[5]
            context.delete(removeData)
        }
        //만약 기존의 검색한 것이 있다면 그전 검색 기록을 지우고 최신에 검색어를 올리기 위함
        if previousStringAddress.contains(name) {
            let index = previousStringAddress.index(of: name)
            let removeData = previousAddresses[index!]
            context.delete(removeData)
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "Towns", in: (self.managedObjectContext)!)
        
        let town = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
        
        town.setValue(name, forKey: "town")
        
        do {
            try self.managedObjectContext?.save()
        }
        catch {
            fatalError("Error in storing data")
        }
    }
}

//MARK: - Extension
//UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if previousAddresses.count == 0 {
            return currentAddresses.count
        }
        return currentAddresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = currentAddresses[indexPath.row]
        return cell
    }
}

//UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //셀을 눌렀을 때의 값을 이용하여 주소값 가져오기
        let name = currentAddresses[indexPath.row]
        
        saveTown(name: name)
        let parameters: [String: String] = ["query": name]
        getCoordinateData(url: kakaoSearchAddressURL, parameters: parameters)
    }
}
