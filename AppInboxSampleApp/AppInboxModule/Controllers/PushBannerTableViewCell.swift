//
//  PushTableViewCell.swift
//  AppInboxSampleApp
//
//  Created by Shubham Naidu on 27/04/23.
//

import UIKit
import WENotificationInbox

class PushBannerTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var readUnreadButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var notificationImageView: UIImageView!
    
    @IBOutlet weak var cardView: UIView!
    
    weak var delegate: InboxCellDelegate?
    var datasource: WEInboxMessage?
    var cellStyle: WEPushCellProtocol  = DefaultTableViewCell()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(inboxData: WEInboxMessage, index: Int, customStyle: WEPushCellProtocol) {
        datasource = inboxData
        self.cellStyle = customStyle
        
        if let pushMessage = datasource?.message as? PushNotificationTemplateData{
            if let title = pushMessage.title {
                self.titleLabel.attributedText = Utils.getAttributedString(rawString: title)
                self.titleLabel.font = UIFont(name: cellStyle.titleFont, size: cellStyle.titleFontSize)
                //                self.titleLabel.textColor = cellStyle.titleFontColor
                // TODO - Fix FontSize
                self.titleLabel.font = UIFont.systemFont(ofSize: 16)
            }
            
            if let description = pushMessage.body{
                self.descriptionLabel.attributedText = Utils.getAttributedString(rawString: description)
                self.descriptionLabel.font = UIFont(name: cellStyle.descriptionFont, size: cellStyle.descriptionFontSize)
                //                self.descriptionLabel.textColor = cellStyle.descriptionFontColor
                // TODO - Fix FontSize
                self.descriptionLabel.font = UIFont.systemFont(ofSize: 14)
            }
            
            if let notificationTime = datasource?.creationTime{
                self.timeLabel.text = "\(Utils.getTimeAgo(notificationTime: notificationTime)) ago."
                self.timeLabel.font = UIFont(name: cellStyle.timeFont, size: 12)
                self.timeLabel.textColor = cellStyle.timeFontColor
                // TODO - Fix FontSize
                self.timeLabel.font = UIFont.systemFont(ofSize: 14)
            }
            
            if let notificationImage = pushMessage.image {
                if let imageURL = URL(string: notificationImage){
                    self.notificationImageView.image = nil
                    URLSession.shared.dataTask(with: imageURL) { data, response, error in
                        guard let data = data, error == nil else { return }
                        DispatchQueue.main.async { // execute on main thread
                            self.notificationImageView.image = UIImage(data: data)
                        }
                    }.resume()
                }
            }
            if let status = datasource?.status{
                if #available(iOS 11.0, *) {
                    if status == "UNREAD" {
                        let image = cellStyle.unReadButtonImage
                        self.readUnreadButton.setImage(image, for: .normal)
                        self.readUnreadButton.tintColor = cellStyle.unReadButtonImageTintColor
                        self.cardView.backgroundColor = customStyle.cardBackgroundColor.withAlphaComponent(0.6)
                    } else if status == "READ" {
                        let image = cellStyle.readButtonImage
                        self.readUnreadButton.setImage(image, for: .normal)
                        self.readUnreadButton.tintColor = cellStyle.readButtonImageTintColor
                        self.cardView.backgroundColor = cellStyle.cardBackgroundColor.withAlphaComponent(1)
                    }
                }
            }
            
            self.cardView.layer.cornerRadius = customStyle.cornerRadius
            self.cardView.layer.shadowColor = customStyle.shadowColor.cgColor
            self.cardView.layer.shadowOffset = CGSize(width: customStyle.shadow0ffSetWidth, height: customStyle.shadow0ffSetHeight)
            self.cardView.layer.shadowOpacity = customStyle.shadowOpacity
            self.deleteButton.setImage(cellStyle.deleteButtonImage, for: .normal)
            self.deleteButton.tintColor = cellStyle.deleteButtonImageTintColor
        }
    }
    
    @IBAction func readUnreadButtonClicked(_ sender: Any) {
        if let datasource = datasource{
            if #available(iOS 13.0, *) {
                if datasource.status == "UNREAD" {
                    delegate?.readEvent(datasource)
                    let image = cellStyle.readButtonImage
                    self.readUnreadButton.setImage(image, for: .normal)
                    self.readUnreadButton.tintColor = cellStyle.readButtonImageTintColor
                    self.datasource?.status = "READ"
                    self.cardView.backgroundColor = cellStyle.cardBackgroundColor.withAlphaComponent(1)
                } else if datasource.status == "READ" {
                    delegate?.unreadEvent(datasource)
                    let image = cellStyle.unReadButtonImage
                    self.readUnreadButton.setImage(image, for: .normal)
                    self.readUnreadButton.tintColor = cellStyle.unReadButtonImageTintColor
                    self.datasource?.status = "UNREAD"
                    self.cardView.backgroundColor = cellStyle.cardBackgroundColor.withAlphaComponent(0.6)
                }
            }
        }
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        delegate?.deleteEvent(datasource, sender: sender)
    }
}
