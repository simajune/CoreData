
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
        btn.backgroundColor = UIColor(red: 140.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        btn.layer.borderWidth = 1
        btn.isSelected = true
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
        coBtn.addTarget(self, action: #selector(coBtnAction(sender:)), for: .touchUpInside)
        co2Btn.addTarget(self, action: #selector(co2BtnAction(sender:)), for: .touchUpInside)
        so2Btn.addTarget(self, action: #selector(so2BtnAction(sender:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pm10BtnClick()
        loadURL()
    }
    
    func pm10BtnClick() {
        pm10Btn.isSelected = true
        pm25Btn.isSelected = false
        coBtn.isSelected = false
        co2Btn.isSelected = false
        so2Btn.isSelected = false
        pm10Btn.backgroundColor = UIColor(red: 140.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        pm25Btn.backgroundColor = .black
        coBtn.backgroundColor = .black
        co2Btn.backgroundColor = .black
        so2Btn.backgroundColor = .black
        scaleImgView.image = UIImage(named: "PMScale")
        let myURL = URL(string: "https://earth.nullschool.net/#current/particulates/surface/level/overlay=pm10/orthographic=-232.65,37.48,1500")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    @objc func pm10BtnAction(sender: UIButton) {
        if sender.isSelected {
            
        }else {
            sender.isSelected = true
            pm25Btn.isSelected = false
            coBtn.isSelected = false
            co2Btn.isSelected = false
            so2Btn.isSelected = false
            sender.backgroundColor = UIColor(red: 140.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            pm25Btn.backgroundColor = .black
            coBtn.backgroundColor = .black
            co2Btn.backgroundColor = .black
            so2Btn.backgroundColor = .black
            scaleImgView.image = UIImage(named: "PMScale")
            let myURL = URL(string: "https://earth.nullschool.net/#current/particulates/surface/level/overlay=pm10/orthographic=-232.65,37.48,1500")
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
    }
    
    @objc func pm25BtnAction(sender: UIButton) {
        if sender.isSelected {
            
        }else {
            sender.isSelected = true
            pm10Btn.isSelected = false
            coBtn.isSelected = false
            co2Btn.isSelected = false
            so2Btn.isSelected = false
            sender.backgroundColor = UIColor(red: 140.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            pm10Btn.backgroundColor = .black
            coBtn.backgroundColor = .black
            co2Btn.backgroundColor = .black
            so2Btn.backgroundColor = .black
            scaleImgView.image = UIImage(named: "PMScale")
            let myURL = URL(string: "https://earth.nullschool.net/#current/particulates/surface/level/overlay=pm2.5/orthographic=-232.65,37.48,1500")
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
    }
    
    @objc func coBtnAction(sender: UIButton) {
        if sender.isSelected {
            
        }else {
            sender.isSelected = true
            pm10Btn.isSelected = false
            pm25Btn.isSelected = false
            co2Btn.isSelected = false
            so2Btn.isSelected = false
            sender.backgroundColor = UIColor(red: 140.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            pm10Btn.backgroundColor = .black
            pm25Btn.backgroundColor = .black
            co2Btn.backgroundColor = .black
            so2Btn.backgroundColor = .black
            scaleImgView.image = UIImage(named: "COScale")
            let myURL = URL(string: "https://earth.nullschool.net/#current/chem/surface/level/overlay=cosc/orthographic=-232.65,37.48,1500")
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
    }
    
    @objc func co2BtnAction(sender: UIButton) {
        if sender.isSelected {
            
        }else {
            sender.isSelected = true
            pm10Btn.isSelected = false
            pm25Btn.isSelected = false
            coBtn.isSelected = false
            so2Btn.isSelected = false
            sender.backgroundColor = UIColor(red: 140.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            pm10Btn.backgroundColor = .black
            pm25Btn.backgroundColor = .black
            coBtn.backgroundColor = .black
            so2Btn.backgroundColor = .black
            scaleImgView.image = UIImage(named: "CO2Scale")
            let myURL = URL(string: "https://earth.nullschool.net/#current/chem/surface/level/overlay=co2sc/orthographic=-232.65,37.48,1500")
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
    }
    
    @objc func so2BtnAction(sender: UIButton) {
        if sender.isSelected {
            
        }else {
            sender.isSelected = true
            pm10Btn.isSelected = false
            pm25Btn.isSelected = false
            coBtn.isSelected = false
            co2Btn.isSelected = false
            sender.backgroundColor = UIColor(red: 140.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            pm10Btn.backgroundColor = .black
            pm25Btn.backgroundColor = .black
            coBtn.backgroundColor = .black
            co2Btn.backgroundColor = .black
            scaleImgView.image = UIImage(named: "SO2Scale")
            let myURL = URL(string: "https://earth.nullschool.net/#current/chem/surface/level/overlay=so2smass/orthographic=-232.65,37.48,1500")
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
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
