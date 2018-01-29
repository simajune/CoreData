//
//  Extension.swift
//  WeatherTejay
//
//  Created by SIMA on 2018. 1. 30..
//  Copyright © 2018년 devtejay. All rights reserved.
//

import Foundation

extension String {
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8)
        return text!
    }
}
