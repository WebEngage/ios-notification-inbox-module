//
//  ViewController.swift
//  AppInboxSampleApp
//
//  Created by Shubham Naidu on 24/04/23.
//

import UIKit
import WebEngage
import WENotificationInbox

class HomeViewController: UIViewController {
    struct Constants {
        
        static let login = "UserDefaults.loginID"
        static let badgeSize: CGFloat = 18
        static let badgeTag: Int = 12
    }
    
    var badgeCount: String?
    var badgeCountLabel = UILabel ()
    @IBOutlet weak var loginButton: UIButton!
    
 
    @IBOutlet weak var notificationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLeftBarButton()
        self.showBadge(withCount: self.badgeCount ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if ((UserDefaults.standard.value(forKey: Constants.login) as? String) != nil) {
            getCount()
        }
    }
    
    @objc private func LoginButtonClicked(_ sender: Any) {
        if ((UserDefaults.standard.value(forKey: Constants.login) as? String) != nil) {
            self.performLogout()
        } else {
            self.performLogin()
        }
    }
    
    @IBAction func notificationButtonClick(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "WENotificationInbox", bundle: nil)
        let inboxViewController = storyBoard.instantiateViewController(withIdentifier: "WENotificationInbox") as! WENotificationInboxViewController
//        inboxViewController.setupCustomConfiguration(customConfiguration: CustomTextCard(), customizationFor: .text)
        
        self.navigationController?.pushViewController(inboxViewController, animated: true)
    }
    
    class CustomTextCard: WEPushTextConfigurationProtocol{
        var titleFontColor: UIColor = .systemPink
        var titleFont: String = "AmericanTypewriter"
        var titleFontSize: CGFloat = 16
        var descriptionFontSize: CGFloat = 18
        var timeFontColor: UIColor = .red
        var timeFont: String = "AmericanTypewriter"
        var timeFormat: String = "EEEE, MMM d, yyyy"
        var timeFontSize: CGFloat = 18
    }

    class  CustommyViewController: WEViewControllerConfigurationProtocol {


        var noNotificationsView: UIView = UIView()
    }
    
    
    private func performLogin() {

        let alert = UIAlertController(title: "Login", message: nil, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Enter Login ID"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Token"
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { [weak self](_) in

            let loginID = alert.textFields![0].text!
            let token = alert.textFields![1].text!

            print("loginID: \(loginID)")

            WebEngage.sharedInstance()?.user.login(loginID, jwtToken:token)

            UserDefaults.standard.set(loginID, forKey: Constants.login)

            self?.setLeftBarButton()
            
            self?.getCount()

            let confirmAlert = UIAlertController(title: "Login Success", message: "You are logged in now with ID: \(loginID)",
                preferredStyle: .alert)

            confirmAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

            self?.present(confirmAlert, animated: true, completion: nil)
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    private func performLogout() {

        if let loginID = UserDefaults.standard.value(forKey: Constants.login) as? String {

            let alert = UIAlertController.init(title: "Logout: \(loginID)", message: nil, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: {[weak self] (_) in
                self?.badgeCountLabel.text = ""
                WebEngage.sharedInstance()?.user.logout()
                UserDefaults.standard.removeObject(forKey: Constants.login)
                self?.setLeftBarButton()
            }))

            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func setLeftBarButton() {
        let button = UIButton()

        button.setTitleColor(.black, for: .normal)

        button.addTarget(self, action: #selector(LoginButtonClicked), for: .touchUpInside)

        if let currentLoginID = UserDefaults.standard.value(forKey: Constants.login) as? String {
            button.setTitle(currentLoginID, for: .normal)
        } else {
            button.setTitle("Login", for: .normal)
        }

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    private func getCount(){
        WENotificationInbox.shared.getUserNotificationCount { [weak self] data, error   in
            if data != nil{
                self?.badgeCount = data as? String
                DispatchQueue.main.async {
                    self?.badgeCountLabel.text = self?.badgeCount
                }
            }else if let weInboxError = error{
                WELogger.d("\(weInboxError.status) \(weInboxError.code) \(weInboxError.localizedDescription)")
            }
        }
    }
    
    private func badgeLabel (withCount count: String) -> UILabel {
        badgeCountLabel = UILabel(frame: CGRect(x: 0, y: 0, width: Constants.badgeSize, height: Constants.badgeSize))
        badgeCountLabel.tag = Constants.badgeTag
        badgeCountLabel.layer.cornerRadius = (badgeCountLabel.bounds.size.height / 2) - 3
        badgeCountLabel.layer.masksToBounds = true
        badgeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeCountLabel.textColor = .white
        badgeCountLabel.font = badgeCountLabel.font.withSize(10)
        badgeCountLabel.textAlignment = .center
        if #available(iOS 11.0, *) {
            badgeCountLabel.backgroundColor = UIColor(named: "CustomBlue")
        } else {
            badgeCountLabel.backgroundColor = .blue
        }
        badgeCountLabel.text = count
        badgeCountLabel.layer.zPosition = 1
        return badgeCountLabel
    }
    
    private func showBadge(withCount count: String) {
        let badge = badgeLabel(withCount: count)
        notificationButton.addSubview(badge)

        NSLayoutConstraint.activate([
            badge.leftAnchor .constraint (equalTo: notificationButton.leftAnchor, constant: 22),
            badge.topAnchor.constraint (equalTo: notificationButton.topAnchor, constant: -5),
            badge.widthAnchor.constraint (equalToConstant: Constants.badgeSize),
            badge.heightAnchor.constraint (equalToConstant: Constants.badgeSize),
                                    ])
        self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(customView:notificationButton))
    }
}

