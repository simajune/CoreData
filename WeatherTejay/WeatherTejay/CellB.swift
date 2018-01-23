//
//  CellB.swift
//  WeatherTejay
//
//  Created by SIMA on 2018. 1. 23..
//  Copyright © 2018년 devtejay. All rights reserved.
//

import UIKit

class CellB: UICollectionViewCell {
    
}

extension CellB: UICollectionViewDelegateFlowLayout {
    
}

extension CellB: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCellB = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCellB", for: indexPath) as! ItemCellB
        return itemCellB
    }
    
    
}
