//
//  LicenseViewController.swift
//  WeatherTejay
//
//  Created by SIMA on 2018. 2. 19..
//  Copyright © 2018년 devtejay. All rights reserved.
//

import UIKit

class LicenseViewController: UIViewController {

    @IBOutlet weak var licenseTxtView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}
