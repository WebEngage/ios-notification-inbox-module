//
//  PushTableViewCell.swift
//  AppInboxSampleApp
//
//  Created by Shubham Naidu on 27/04/23.
//

import UIKit
import WENotificationInbox

class WEPushTextTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var readUnreadButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var cardView: UIView!
    
    weak var delegate: InboxCellDelegate?
    weak var datasource: WEInboxMessage?
    var cellStyle = DefaultCellConfiguration()
    var customConfiguration: WEPushConfigurationProtocol?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(inboxData: WEInboxMessage, index: Int, cellConfiguration: AnyObject) {
        datasource = inboxData
        cellStyle = WEUtils.setupCustomConfiguration(customConfiguration: cellConfiguration, cellStyle: cellStyle)
        
        if let pushMessage = datasource?.message as? PushNotificationTemplateData{
            
            if let title = pushMessage.title {
                let attributedTitle = WEUtils.getAttributedString(rawString: title, forLabelType: .title, withSize: cellStyle.titleFontSize, withFont: cellStyle.titleFont, withColor: cellStyle.titleFontColor)
                self.titleLabel.attributedText = attributedTitle
            }
            
            if let description = pushMessage.body{
                self.descriptionLabel.attributedText = WEUtils.getAttributedString(rawString: description, forLabelType: .description, withSize: cellStyle.descriptionFontSize, withFont: cellStyle.descriptionFont, withColor: cellStyle.descriptionFontColor)
            }
            
            if let notificationTime = datasource?.creationTime{
                var time: String
                if cellStyle.timeFormat.isEmpty {
                    time = "\(WEUtils.getTimeAgo(notificationTime: notificationTime)) ago."
                }else{
                    let timeFormat = cellStyle.timeFormat
                    time = WEUtils.getTime(withFormat: timeFormat, forTime: notificationTime)
                }
                self.timeLabel.attributedText = WEUtils.getAttributedString(rawString: time, forLabelType: .time, withSize: cellStyle.timeFontSize, withFont: cellStyle.timeFont, withColor: cellStyle.timeFontColor)
            }
        }
        if !(cellStyle.readUnreadButtonVisibility) {
            readUnreadButton.isHidden = true
        } else {
            readUnreadButton.isHidden = false
        }
        
        if !(cellStyle.deleteButtonVisibility){
            deleteButton.isHidden = true
        } else {
            deleteButton.isHidden = false
        }
        
        if let status = datasource?.status{
            if #available(iOS 11.0, *) {
                if status == "UNREAD" {
                    let image = cellStyle.unReadButtonImage
                    self.readUnreadButton.setImage(image, for: .normal)
                    self.readUnreadButton.tintColor = cellStyle.unReadButtonImageTintColor
                    self.cardView.backgroundColor = cellStyle.cardBackgroundColor.withAlphaComponent(0.6)
                } else if status == "READ" {
                    let image = cellStyle.readButtonImage
                    self.readUnreadButton.setImage(image, for: .normal)
                    self.readUnreadButton.tintColor = cellStyle.readButtonImageTintColor
                    self.cardView.backgroundColor = cellStyle.cardBackgroundColor.withAlphaComponent(1)
                }
            }
        }
        
        
        self.cardView.layer.cornerRadius = cellStyle.cornerRadius
        self.cardView.layer.shadowColor = cellStyle.shadowColor.cgColor
        self.cardView.layer.shadowOffset = CGSize(width: cellStyle.shadow0ffSetWidth, height: cellStyle.shadow0ffSetHeight)
        self.cardView.layer.shadowOpacity = cellStyle.shadowOpacity
        self.deleteButton.setImage(cellStyle.deleteButtonImage, for: .normal)
        self.deleteButton.tintColor = cellStyle.deleteButtonImageTintColor
        self.contentView.backgroundColor = .init(white: 1.0, alpha: 0.9)
        
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
