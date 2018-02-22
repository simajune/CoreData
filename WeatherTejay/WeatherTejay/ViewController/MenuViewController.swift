
import UIKit
import MessageUI

class MenuViewController: UIViewController, MFMailComposeViewControllerDelegate {
    //테이블 뷰이기 때문에 메뉴를 구성할 항목들을 배열로 저장. 만약 메뉴 추가할 것이 생기면 배열에 추가하면 됨
    var menuTitle: [String] = ["날씨먼지에 대해", "오픈소스 라이센스", "개발자에게 한마디"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //메뉴가 가리는 정도를 나타냄. 현재는 우측 60만큼 남겨둔 상태로 메뉴 뷰가 생김
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    }
}

//MARK: - extension
//UITableViewDelegate
extension MenuViewController: UITableViewDelegate {
    //메뉴 선택에 따라 Segue를 선택
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "ToAbout", sender: nil)
        }else if indexPath.row == 1 {
            performSegue(withIdentifier: "ToLicense", sender: nil)
        }else {
            sendEmail()
        }
    }
    //메일 보내는 메소드
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["tejayjung@gmail.com"])
            mail.setSubject("날씨먼지 문의")
            mail.setMessageBody("<p>개발자에게 불편사항이나 문의사항을 적어주세요</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    //메일을 보낸 후 이전 화면으로 돌아가기 위함
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
//UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    //메뉴의 수 = 배열의 카운트
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitle.count
    }
    //테이블뷰 셀의 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        cell.titleLabel.text = menuTitle[indexPath.row]
        return cell
    }
}
