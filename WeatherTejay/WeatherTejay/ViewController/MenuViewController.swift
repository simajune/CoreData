
import UIKit
import MessageUI

class MenuViewController: UIViewController, MFMailComposeViewControllerDelegate {

    var menuTitle: [String] = ["먼지날씨에 대해", "오픈소스 라이센스", "개발자에게 한마디"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        // Do any additional setup after loading the view.
    }
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "ToAbout", sender: nil)
        }else if indexPath.row == 1 {
            performSegue(withIdentifier: "ToLicense", sender: nil)
        }else {
            sendEmail()
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["tejayjung@gmail.com"])
            mail.setSubject("먼지날씨 문의")
            mail.setMessageBody("<p>개발자에게 불편사항이나 문의사항을 적어주세요</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        cell.titleLabel.text = menuTitle[indexPath.row]
        return cell
    }
    
}
