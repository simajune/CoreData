
import UIKit

class BulletinViewController: UIViewController {

    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var popHeaderView: UIView!
    @IBOutlet weak var popHeaderInnerView: UIView!
    @IBOutlet weak var bulletinTitle: UILabel!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var neverBtn: UIButton!
    @IBOutlet weak var popViewCenterY: NSLayoutConstraint!
    @IBOutlet weak var popviewContent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popViewCenterY.constant = 1000
        setupUI()
        reviewBtn.addTarget(self, action: #selector(reviewBtnAction(sender:)), for: UIControlEvents.touchUpInside)
        nextBtn.addTarget(self, action: #selector(nextBtnAction(sender:)), for: UIControlEvents.touchUpInside)
        neverBtn.addTarget(self, action: #selector(neverBtnAction(sender:)), for: UIControlEvents.touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1.0) {
            self.popViewCenterY.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupUI() {
        popView.layer.cornerRadius = 5
        popHeaderView.layer.cornerRadius = (popHeaderView.bounds.height / 2)
        popHeaderInnerView.layer.cornerRadius = (popHeaderInnerView.bounds.height / 2)
        reviewBtn.layer.cornerRadius = 5
        nextBtn.layer.cornerRadius = 5
        neverBtn.layer.cornerRadius = 5
    }
    
    @objc func reviewBtnAction(sender: UIButton) {
        
    }
    
    @objc func nextBtnAction(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func neverBtnAction(sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "isNeverBulletin")
        dismiss(animated: true, completion: nil)
    }
}
