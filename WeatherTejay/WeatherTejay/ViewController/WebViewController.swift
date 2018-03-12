
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
        btn.layer.borderWidth = 1
        btn.setTitle("미세먼지", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Yanolja Yache OTF", size: 17)
        return btn
    }()
    var pm25Btn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.layer.borderWidth = 1
        btn.setTitle("초미세먼지", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Yanolja Yache OTF", size: 17)
        return btn
    }()
    var coBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.layer.borderWidth = 1
        btn.setTitle("일산화탄소", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Yanolja Yache OTF", size: 17)
        return btn
    }()
    var co2Btn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.layer.borderWidth = 1
        btn.setTitle("이산화탄소", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Yanolja Yache OTF", size: 17)
        return btn
    }()
    var so2Btn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.layer.borderWidth = 1
        btn.setTitle("아황산가스", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Yanolja Yache OTF", size: 17)
        return btn
    }()
    var dustStackView: UIStackView!
    var scaleImgView: UIImageView!
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
            $0.bottom.equalTo(containerView).multipliedBy(1.05)
        }
        
        //CoverView Setting
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
        
        
        
        scaleImgView = UIImageView(frame: CGRect.zero)
        coverView.addSubview(scaleImgView)
        scaleImgView.image = UIImage(named: "PMScale")
        scaleImgView.snp.makeConstraints {
            $0.left.right.equalTo(containerView)
            $0.bottom.equalTo(containerView).offset(-1)
            $0.height.equalTo(20)
        }
        
        //StackView Setting
        dustStackView = UIStackView(frame: .zero)
        dustStackView = UIStackView(arrangedSubviews: [pm10Btn, pm25Btn, coBtn, co2Btn, so2Btn])
        dustStackView.alignment = .fill
        dustStackView.distribution = .fillEqually
        dustStackView.axis = .horizontal
        coverView.addSubview(dustStackView)
        dustStackView.snp.makeConstraints {
            $0.left.right.equalTo(containerView)
            $0.bottom.equalTo(scaleImgView).offset(-21)
            $0.height.equalTo(40)
        }
    }
    
    func loadURL() {
        
//        let myURL = URL(string: "https://earth.nullschool.net/")

        let myURL = URL(string: "https://earth.nullschool.net/#current/particulates/surface/level/overlay=pm10/orthographic=-232.65,38.48,1500")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
}
