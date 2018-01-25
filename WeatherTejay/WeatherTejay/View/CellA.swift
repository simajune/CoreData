//
//  CellA.swift
//  WeatherTejay
//
//  Created by SIMA on 2018. 1. 23..
//  Copyright © 2018년 devtejay. All rights reserved.
//

import UIKit

class CellA: UICollectionViewCell, MainDelegate {
    
    //MARK: - Variable
    var cellCount: Int = 0
    let mainViewController = MainViewController()
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        print(cellCount)
        mainViewController.delegate = self
    }
    
    func updateCell(count: Int) {
        print("Hi")
        cellCount = count
        forecastCollectionView.reloadData()
    }

}

extension CellA: UICollectionViewDelegateFlowLayout {
    
}

extension CellA: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemCellA = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCellA", for: indexPath) as! ItemCellA
        return itemCellA
    }
}

extension CellA: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 5, height: self.frame.height)
    }
}
