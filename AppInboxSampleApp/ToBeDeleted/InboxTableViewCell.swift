////
////  ViewController.swift
////  AppInboxSampleApp
////
////  Created by Shubham Naidu on 24/04/23.
////
//
//
//import Foundation
//import UIKit
//import WENotificationInbox
//
//class InboxTableViewCell: UITableViewCell {
//    weak var delegate: InboxCellDelegate?
//    var datasource: WEInboxMessage?
//    var index: Int = 1
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
//
//    @IBOutlet weak var readUnreadButton: UIButton!
//
//    @IBOutlet weak var stackView: UIStackView!
//    @IBOutlet weak var notificationImageView: UIImageView!
//    @IBOutlet weak var deleteButton: UIButton!
//    @IBOutlet weak var titleLabel: UILabel!
//
//    @IBOutlet weak var descriptionLabel: UILabel!
//
//    @IBOutlet weak var timeLabel: UILabel!
//
//    @IBOutlet weak var weConfigurableView: WEConfigureView!
//
//    func setupCell(inboxData: WEInboxMessage, index: Int) {
//        datasource = inboxData
//        self.notificationImageView.isHidden = true
//        self.notificationImageView.image = nil
//        delegate?.height(weConfigurableView.cellHeight)
//        weConfigurableView.translatesAutoresizingMaskIntoConstraints = false
//
////        if let title = datasource?.getTitle(){
////       -----Use this block if you want to use Rich Text.-----
//            self.titleLabel.attributedText = getAttributedString(rawString: title)
//            self.titleLabel.font = titleLabel.font.withSize(16)
//
////      -----Use this block if you ant ot use custom fonts.-----
////            self.titleLabel.text = getAttributedString(rawString: title).string
////            self.titleLabel.font = UIFont(name: "AmericanTypewriter-Semibold", size: 14)
//        }
//        
//        if let description = datasource?.getDescription(){
////       -----Use this block if you want to use Rich Text.-----
//            self.descriptionLabel.attributedText = getAttributedString(rawString: description)
//            self.descriptionLabel.font = descriptionLabel.font.withSize(14)
//
////       -----Use this block if you ant ot use custom fonts.-----
////            self.descriptionLabel.text = getAttributedString(rawString: description).string
////            self.descriptionLabel.font = UIFont(name: "AmericanTypewriter", size: 12)
//        }
//        
//        if let notificationTime = datasource?.creationTime{
//            self.timeLabel.text = "\(getTimeAgo(notificationTime: notificationTime)) ago."
//
////       -----Use this block if you ant ot use custom fonts.-----
////            self.timeLabel.font = UIFont(name: "AmericanTypewriter-Semibold", size: 12)
//        }
//        
//        if let notificationImage = datasource?.getImage(){
//            if let imageURL = URL(string: notificationImage){
//                self.notificationImageView.isHidden = false
//                self.notificationImageView.layer.cornerRadius = weConfigurableView.cornerRadius
//                
//                URLSession.shared.dataTask(with: imageURL) { data, response, error in
//                    guard let data = data, error == nil else { return }
//                    DispatchQueue.main.async { /// execute on main thread
//                        self.notificationImageView.image = UIImage(data: data)
//                    }
//                }.resume()
//            }
//            else {
//                self.notificationImageView.isHidden = true
//            }
//        }
//        if let status = datasource?.status{
//            if #available(iOS 11.0, *) {
//                if status == "UNREAD" {
//                    let image = weConfigurableView.unReadButtonImage
//                    self.readUnreadButton.setImage(image, for: .normal)
//                    self.readUnreadButton.tintColor = weConfigurableView.unReadButtonImageTintColor
//                    self.weConfigurableView.backgroundColor = weConfigurableView.cardBackgroundColor?.withAlphaComponent(0.8)
////                    self.stackView.backgroundColor = UIColor(white: 0.95, alpha: 1)
//                } else if status == "READ" {
//                    let image = weConfigurableView.readButtonImage
//                    self.readUnreadButton.setImage(image, for: .normal)
//                    self.readUnreadButton.tintColor = weConfigurableView.readButtonImageTintColor
//                    self.weConfigurableView.backgroundColor = weConfigurableView.cardBackgroundColor
////                    self.stackView.backgroundColor = UIColor(white: 1, alpha: 1)
//                }
//            }
//        }
//    }
//
//    private func getAttributedString(rawString: String) -> NSAttributedString {
//        var text:NSAttributedString = NSAttributedString()
//        if let data = rawString.data(using: .utf8),
//            let attribStr = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) {
//                text = attribStr
//            }
//        return text
//    }
//
//    private func getTimeAgo(notificationTime : String) -> String{
//        let formatter = DateComponentsFormatter()
//        formatter.unitsStyle = .full
//        formatter.maximumUnitCount = 1
//        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//
//        if let pastDate = dateFormatter.date(from:notificationTime) {
//            if let timeAgo = formatter.string(from: pastDate, to: Date()){
//                return timeAgo
//            }
//        }
//        return "\(notificationTime)"
//    }
//
//    @IBAction func readUnreadButtonClicked(_ sender: Any) {
//        if let datasource = datasource{
//            if #available(iOS 13.0, *) {
//                if datasource.status == "UNREAD" {
//                    delegate?.readEvent(datasource)
//                    let image = weConfigurableView.readButtonImage
//                    self.readUnreadButton.setImage(image, for: .normal)
//                    self.readUnreadButton.tintColor = weConfigurableView.readButtonImageTintColor
//                    self.datasource?.status = "READ"
//                    self.weConfigurableView.backgroundColor = weConfigurableView.cardBackgroundColor
////                    self.stackView.backgroundColor = UIColor(white: 1, alpha: 1)
//                } else if datasource.status == "READ" {
//                    delegate?.unreadEvent(datasource)
//                    let image = weConfigurableView.unReadButtonImage
//                    self.readUnreadButton.setImage(image, for: .normal)
//                    self.readUnreadButton.tintColor = weConfigurableView.unReadButtonImageTintColor
//                    self.datasource?.status = "UNREAD"
//                    self.weConfigurableView.backgroundColor = weConfigurableView.cardBackgroundColor?.withAlphaComponent(0.8)
////                    self.stackView.backgroundColor = UIColor(white: 0.95, alpha: 1)
//                }
//            }
//        }
//    }
//    
//    @IBAction func deleteButtonClicked(_ sender: Any) {
//        delegate?.deleteEvent(datasource, sender: sender)
//    }
//
//    @IBAction func readAction(_ sender: Any) {
//        delegate?.readEvent(datasource)
//    }
//
//    @IBAction func unreadAction(_ sender: Any) {
//        delegate?.unreadEvent(datasource)
//    }
//
//    @IBAction func clickAction(_ sender: Any) {
//        delegate?.clickEvent(datasource)
//    }
//
//    @IBAction func deleteAction(_ sender: Any) {
//        delegate?.deleteEvent(datasource, sender: sender)
//    }
//}
