
import UIKit

class BulletinViewController: UIViewController {

    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var popHeaderView: UIView!
    @IBOutlet weak var popHeaderInnerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        popView.layer.cornerRadius = 5
        popHeaderView.layer.cornerRadius = (popHeaderView.bounds.height / 2)
        popHeaderInnerView.layer.cornerRadius = (popHeaderInnerView.bounds.height / 2)
    }
}
