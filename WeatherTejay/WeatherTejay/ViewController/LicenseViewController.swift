
import UIKit

class LicenseViewController: UIViewController {

    @IBOutlet weak var licenseTxtView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}
