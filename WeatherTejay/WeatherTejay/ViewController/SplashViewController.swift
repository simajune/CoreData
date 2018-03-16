
import UIKit

class SplashViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.alpha = 0
        UIView.animate(withDuration: 2.0, animations: {
            self.titleLabel.alpha = 1.0
        }) { (true) in
            self.performSegue(withIdentifier: "ToMain", sender: nil)
        }
    }
}
