
import UIKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }


}

extension MainViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 1 {
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "cellB", for: indexPath) as! CellB
            return cellB
        }
        let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "cellA", for: indexPath) as! CellA
        
        return cellA
    }
    
    
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 1 {
            return CGSize(width: self.view.frame.width, height: 500)
        }else {
            return CGSize(width: self.view.frame.width, height: 300)
        }
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
}
