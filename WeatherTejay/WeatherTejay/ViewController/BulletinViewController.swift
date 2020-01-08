
import UIKit
import Firebase

class BulletinViewController: UIViewController {

    //MARK: - Property
    let reference = Database.database().reference()
    let bulletinTitle: String = "'날씨먼지' 안내사항"
    let bulletinContent: String = "- 미세먼지 정보가 측정소의 문제로 정보를 받아오지 못할 때가 있습니다. 그럴 경우, 잠시 뒤에 다시 시도해 주시기 바랍니다.\n\n- 'Map' 탭은 대략적인 미세먼지의 농도를 보는 곳입니다. 수치는 알 수 없습니다.\n\n- '날씨먼지' 앱을 이용해 주셔서 감사합니다. 도움이 되는 앱이 되도록 노력하겠습니다."
    //MARK: - IBOulet
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var popHeaderView: UIView!
    @IBOutlet weak var popHeaderInnerView: UIView!
    @IBOutlet weak var bulletinTitleLabel: UILabel!
    @IBOutlet weak var bulletinContentLabel: UILabel!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var neverBtn: UIButton!
    @IBOutlet weak var popViewCenterY: NSLayoutConstraint!
    @IBOutlet weak var popviewContent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popViewCenterY.constant = 1000
        setupUI()
        reference.child("isBulletin").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            guard let `self` = self else { return }
            if let value = snapshot.value as? [String: Any] {
                self.bulletinTitleLabel.text = value["title"] as? String
                self.bulletinContentLabel.text = value["content"] as? String
            }
            
        }) { (error) in
            print(error)
            self.bulletinTitleLabel.text = self.bulletinTitle
            self.bulletinContentLabel.text = self.bulletinContent
        }
        reviewBtn.addTarget(self, action: #selector(reviewBtnAction(sender:)), for: UIControlEvents.touchUpInside)
        nextBtn.addTarget(self, action: #selector(nextBtnAction(sender:)), for: UIControlEvents.touchUpInside)
        neverBtn.addTarget(self, action: #selector(neverBtnAction(sender:)), for: UIControlEvents.touchUpInside)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5) {
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
        let url = URL(string: "https://itunes.apple.com/kr/app/%EB%82%A0%EC%94%A8%EB%A8%BC%EC%A7%80-%EB%82%A0%EC%94%A8-%EB%AF%B8%EC%84%B8%EB%A8%BC%EC%A7%80/id1350615467?mt=8")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @objc func nextBtnAction(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func neverBtnAction(sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "isNeverBulletin")
        dismiss(animated: true, completion: nil)
    }
}
