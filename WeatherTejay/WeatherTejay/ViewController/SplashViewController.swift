
import UIKit
import Firebase

class SplashViewController: UIViewController {

    var isBulletin: Int = 0
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.alpha = 0
        
        UIView.animate(withDuration: 2.0, animations: {
            self.titleLabel.alpha = 1.0
        }) { (true) in
            self.performSegue(withIdentifier: "ToMain", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Tomain" {
            let mainView = segue.destination as! MainViewController
            
        }
    }
}
