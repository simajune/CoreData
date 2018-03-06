
import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var aboutTxtView: UITextView!
    @IBOutlet weak var gradeTxtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutTxtView.font = UIFont(name: "Yanolja Yache OTF", size: 17)
        gradeTxtView.font = UIFont(name: "Yanolja Yache OTF", size: 17)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
