
import UIKit
import SnapKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    var testView: UIView!
    var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    var pm10Btn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.setTitle("PM10", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    var pm25Btn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.setTitle("PM2.5", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    
    @IBOutlet weak var navibarView: UIView!
    @IBOutlet weak var containerView: UIView!
    //Navigation
    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //메뉴 버튼에 대한 메소드 설정
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        //매뉴를 보기 위한 조건들 추가 - 오른쪽으로 슬라이드
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        pm10Btn.addTarget(self, action: #selector(pm10BtnAction(sender:)), for: .touchUpInside)
        pm25Btn.addTarget(self, action: #selector(pm25BtnAction(sender:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(containerView.frame.height)
        print(webView.frame.height)
        print(webView.scrollView.frame.height)
        loadURL()
    }
    
    @objc func pm10BtnAction(sender: UIButton) {
        print("pm10")
    }
    
    @objc func pm25BtnAction(sender: UIButton) {
        print("pm2.5")
    }
    
    func setupUI() {
        //WebView Setting
        let webConfiduration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiduration)
        webView.uiDelegate = self
        self.view.addSubview(webView)
        
        webView.snp.makeConstraints {
            $0.top.left.right.equalTo(containerView)
//            $0.bottom.equalTo(containerView)
            $0.bottom.equalTo(containerView).multipliedBy(1.05)
        }
        
        
        webView.addSubview(coverView)
        coverView.snp.makeConstraints {
            $0.top.bottom.left.right.equalTo(containerView)
        }
        
        //Button Setting
        coverView.addSubview(pm10Btn)
        pm10Btn.snp.makeConstraints {
            $0.centerX.equalTo(containerView).multipliedBy(1.7)
            $0.centerY.equalTo(containerView).multipliedBy(1.7)
            $0.height.equalTo(50)
            $0.width.equalTo(containerView).multipliedBy(0.2)
        }
    }
    
    func loadURL() {
        
//        let myURL = URL(string: "https://earth.nullschool.net/")

        let myURL = URL(string: "https://earth.nullschool.net/#current/particulates/surface/level/overlay=pm10/orthographic=-232.65,38.48,1500")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
}
