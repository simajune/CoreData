
import UIKit
import SnapKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    
    @IBOutlet weak var navibarView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiduration = WKWebViewConfiguration()
        
        webView = WKWebView(frame: .zero, configuration: webConfiduration)
        self.view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.top.bottom.left.right.equalTo(containerView)
        }
        loadURL()
    }
    
    func loadURL() {
        let myURL = URL(string: "https://earth.nullschool.net/#current/particulates/surface/level/overlay=pm10/orthographic=-231.37,36.93,1930/loc=126.593,38.140")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
}
