
import UIKit
import SnapKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    
    @IBOutlet weak var navibarView: UIView!
    @IBOutlet weak var containerView: UIView!
    //Navigation
    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiduration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiduration)
        self.view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.top.bottom.left.right.equalTo(containerView)
        }
        //메뉴 버튼에 대한 메소드 설정
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        //매뉴를 보기 위한 조건들 추가 - 오른쪽으로 슬라이드
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        setupWebView()
    }
    
    func setupWebView() {
        
        let myURL = URL(string: "https://earth.nullschool.net/")

//        let myURL = URL(string: "https://earth.nullschool.net/#current/particulates/surface/level/overlay=pm2.5/orthographic=-233.74,38.18,2000/loc=125.820,38.707")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
}
