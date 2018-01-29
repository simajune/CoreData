//
//  SearchViewController.swift
//  WeatherTejay
//
//  Created by SIMA on 2018. 1. 29..
//  Copyright © 2018년 devtejay. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchViewController: UIViewController {

    var totalAddresses: [String] = []
    var previousAddresses: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            if let path = Bundle.main.path(forResource: "addresses", ofType: "json"),
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
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalAddresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = totalAddresses[indexPath.row]
        //cell.addressLabel.text = totalAddresses[indexPath.row]
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
}

