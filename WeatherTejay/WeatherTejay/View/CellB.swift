//
//  CellB.swift
//  WeatherTejay
//
//  Created by SIMA on 2018. 1. 23..
//  Copyright © 2018년 devtejay. All rights reserved.
//

import UIKit

class CellB: UICollectionViewCell {
    //MARK: - Variable
    var cellCount: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

extension CellB: UICollectionViewDelegateFlowLayout {
    
}

extension CellB: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCellB = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCellB", for: indexPath) as! ItemCellB
        return itemCellB
    }
}

extension CellB: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height / 6)
    }
}
