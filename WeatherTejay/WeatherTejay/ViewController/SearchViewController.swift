
import UIKit
import SwiftyJSON
import Alamofire

class SearchViewController: UIViewController {

    var sidoNameArray: [String] = []
    var sggNameArray: [String] = []
    var umdNameArray: [String] = []
    var totalAddresses: [String] = []
    var previousAddresses: [String] = []
    
    @IBOutlet weak var addressTablewView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
                    }
                    //print(self.totalAddresses)
                }
                print(self.totalAddresses.count)
            }
/////////////////////////////////////////////////////
            if let path = Bundle.main.path(forResource: "Addresses1", ofType: "json"), let contents = try? String(contentsOfFile: path), let data = contents.data(using: .utf8) {
                if let addressJSON: JSON = try? JSON(data: data) {
                    for addressName in addressJSON["addresses"] {
                        self.sidoNameArray.append(String(describing: addressName.1["sidoName"]))
                        self.sggNameArray.append(String(describing: addressName.1["sggName"]))
                        self.umdNameArray.append(String(describing: addressName.1["umdName"]))
                    }
                    self.addressTablewView.reloadData()
                }
            }
            
        }
    }
    
    func setTMCoordinateData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            print(response.request)
            print(JSON(response.result.value))
//            if response.result.isSuccess {
//                print(parameters["umdName"])
//                print(response.result.value)
//            }else {
//                print(response.result.error)
//                print(parameters["umdName"])
//            }
        }
    }
    
    @IBAction func dismissBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if previousAddresses.count == 0 {
            return totalAddresses.count
        }
        return previousAddresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = totalAddresses[indexPath.row]
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let umdName = umdNameArray[indexPath.row]
        print(umdName)
        umdName.utf8EncodedString()
        
        let parameters: [String: String] = ["umdName": umdName, "pageNo": "1", "numOfRows": "10", "ServiceKey": dustAPIKey]
        setTMCoordinateData(url: getTMdustURL, parameters: parameters)
    }
}

