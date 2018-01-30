
import UIKit

//extension UISearchBar {
//    func changeSearchBarColor(color: UIColor) {
//        UIGraphicsBeginImageContext(self.frame.size)
//        color.setFill()
//        UIBezierPath(rect: self.frame).fill()
//        let bgImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        
//        self.setSearchFieldBackgroundImage(bgImage, for: .normal)
//    }
//}

// as UISearchBar extension
extension UISearchBar {
    func changeSearchBarColor(color : UIColor) {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                
                if let _ = subSubView as? UITextInputTraits {
                    let textField = subSubView as! UITextField
                    textField.backgroundColor = color
                    break
                }
                
            }
        }
    }
}
