//
//  CellA.swift
//  WeatherTejay
//
//  Created by SIMA on 2018. 1. 23..
//  Copyright © 2018년 devtejay. All rights reserved.
//

import UIKit

class CellA: UICollectionViewCell {
    
}

extension CellA: UICollectionViewDelegateFlowLayout {
    
}

extension CellA: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCellA = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCellA", for: indexPath) as! ItemCellA
        return itemCellA
    }
    
    
}
