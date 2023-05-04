//
//  PushTableViewCell.swift
//  AppInboxSampleApp
//
//  Created by Shubham Naidu on 27/04/23.
//

import UIKit
import WENotificationInbox

class WEPushBannerTableViewCell: UITableViewCell {
    
    
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
    var cellStyle = DefaultCellConfiguration()
    var customConfiguration: WEPushCellConfigurationProtocol?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(inboxData: WEInboxMessage, index: Int, cellConfiguration: AnyObject) {
        datasource = inboxData
        setupCustomConfiguration(customConfiguration: cellConfiguration)
        
//        self.cellStyle = cellConfiguration
        
        if let pushMessage = datasource?.message as? PushNotificationTemplateData{
            if let title = pushMessage.title {
                self.titleLabel.attributedText = WEUtils.getAttributedString(rawString: title)
                self.titleLabel.font = UIFont(name: cellStyle.titleFont, size: cellStyle.titleFontSize)
                //                self.titleLabel.textColor = cellStyle.titleFontColor
                // TODO - Fix FontSize
                self.titleLabel.font = UIFont.systemFont(ofSize: 16)
            }
            
            if let description = pushMessage.body{
                self.descriptionLabel.attributedText = WEUtils.getAttributedString(rawString: description)
                self.descriptionLabel.font = UIFont(name: cellStyle.descriptionFont, size: cellStyle.descriptionFontSize)
                //                self.descriptionLabel.textColor = cellStyle.descriptionFontColor
                // TODO - Fix FontSize
                self.descriptionLabel.font = UIFont.systemFont(ofSize: 14)
            }
            
            if let notificationTime = datasource?.creationTime{
                self.timeLabel.text = "\(WEUtils.getTimeAgo(notificationTime: notificationTime)) ago."
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
                            self.notificationImageView.layer.cornerRadius = self.cellStyle.imageViewCornerRadius
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
        }
    }
    
    func setupCustomConfiguration(customConfiguration: AnyObject){
        
        if let customConfig = customConfiguration as? WEPushCardConfigutationProtocol{
            cellStyle.cornerRadius = customConfig.cornerRadius
            cellStyle.shadowColor = customConfig.shadowColor
            cellStyle.shadow0ffSetWidth = customConfig.shadow0ffSetWidth
            cellStyle.shadow0ffSetWidth = customConfig.shadow0ffSetWidth
            cellStyle.shadowOpacity = customConfig.shadowOpacity
            cellStyle.cardBackgroundColor = customConfig.cardBackgroundColor
        }
        
        if let customConfig =  customConfiguration as? WEPushButtonConfigurationProtocol{
            cellStyle.readButtonImage = customConfig.readButtonImage
            cellStyle.readButtonImageTintColor = customConfig.readButtonImageTintColor
            cellStyle.unReadButtonImage = customConfig.unReadButtonImage
            cellStyle.unReadButtonImageTintColor = customConfig.unReadButtonImageTintColor
            cellStyle.deleteButtonImage = customConfig.deleteButtonImage
            cellStyle.deleteButtonImageTintColor = customConfig.deleteButtonImageTintColor
        }
        
        if let customConfig =  customConfiguration as? WEPushLabelConfigurationProtocol{
            cellStyle.titleFont = customConfig.titleFont
            cellStyle.titleFontSize = customConfig.titleFontSize
            cellStyle.titleFontColor = customConfig.titleFontColor
            cellStyle.descriptionFont = customConfig.descriptionFont
            cellStyle.descriptionFontSize = customConfig.descriptionFontSize
            cellStyle.descriptionFontColor = customConfig.descriptionFontColor
            
            cellStyle.timeFont = customConfig.timeFont
            cellStyle.timeFontSize = customConfig.timeFontSize
            cellStyle.timeFontColor = customConfig.timeFontColor
        }
        
        if let customConfig =  customConfiguration as? WEPushBannerConfigurationProtocol{
            cellStyle.imageViewCornerRadius = customConfig.imageViewCornerRadius
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