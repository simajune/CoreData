
import UIKit

extension DateFormatter {
    func date(fromSwapiString dateString: String) -> Date? {
        // SWAPI dates look like: "2014-12-10T16:44:31.486000Z"
        self.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.timeZone = TimeZone(abbreviation: "UTC")
        self.locale = Locale(identifier: "ko_KR")
        return self.date(from: dateString)
    }
}

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
