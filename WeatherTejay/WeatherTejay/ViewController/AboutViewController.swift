//
//  AboutViewController.swift
//  WeatherTejay
//
//  Created by SIMA on 2018. 2. 17..
//  Copyright © 2018년 devtejay. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var aboutTxtView: UITextView!
    @IBOutlet weak var gradeTxtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutTxtView.font = UIFont(name: "Yanolja Yache OTF", size: 17)
        gradeTxtView.font = UIFont(name: "Yanolja Yache OTF", size: 17)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
