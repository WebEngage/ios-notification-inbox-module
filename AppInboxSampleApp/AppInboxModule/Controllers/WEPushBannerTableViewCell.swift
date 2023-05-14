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
        setupCustomConfiguration(customConfiguration: cellConfiguration)
        
        if let pushMessage = datasource?.message as? PushNotificationTemplateData{
            if let title = pushMessage.title {
                self.titleLabel.attributedText = WEUtils.getAttributedString(rawString: title)
                self.titleLabel.font = UIFont.systemFont(ofSize: cellStyle.titleFontSize)
                var font: UIFont?
                if cellStyle.titleFont != "" {
                    font = UIFont(name: cellStyle.titleFont, size: 16)
                }
                if cellStyle.titleFontSize != 16 {
                    font = UIFont(name: cellStyle.titleFont, size: cellStyle.titleFontSize)
                }
                if cellStyle.titleFontColor != .black {
                    self.titleLabel.textColor = cellStyle.titleFontColor
                }
                if font != nil {
                    self.titleLabel.font = font
                }
            }
            
            if let description = pushMessage.body{
                self.descriptionLabel.attributedText = WEUtils.getAttributedString(rawString: description)
                self.descriptionLabel.font = UIFont.systemFont(ofSize: cellStyle.descriptionFontSize)
                var font: UIFont?
                if cellStyle.descriptionFont != "" {
                    font = UIFont(name: cellStyle.descriptionFont, size: 14)
                }
                if cellStyle.descriptionFontSize != 14 {
                    font = UIFont(name: cellStyle.descriptionFont, size: cellStyle.descriptionFontSize)
                }
                if cellStyle.descriptionFontColor != .black {
                    self.descriptionLabel.textColor = cellStyle.descriptionFontColor
                }
                if font != nil{
                    self.descriptionLabel.font = font
                }
            }
            
            if let notificationTime = datasource?.creationTime{
                
                if cellStyle.timeFormat == "yyyy-MM-dd'T'HH:mm:ss.SSSZ" {
                    self.timeLabel.text = "\(WEUtils.getTimeAgo(notificationTime: notificationTime)) ago."
                }else{
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    if let date = dateFormatter.date(from: notificationTime) {
                        dateFormatter.dateFormat = cellStyle.timeFormat
                        let formattedDate = dateFormatter.string(from: date)
                        self.timeLabel.text = formattedDate.description
                    }
                }
                var font: UIFont?
                if cellStyle.timeFont != "" {
                    font = UIFont(name: cellStyle.timeFont, size: 14)
                }
                if cellStyle.timeFontSize != 14 {
                    font = UIFont(name: cellStyle.timeFont, size: cellStyle.timeFontSize)
                }
                if font != nil{
                    self.timeLabel.font = font
                }
                self.timeLabel.textColor = cellStyle.timeFontColor
            }
            
            if let notificationImage = pushMessage.image {
                if let imageURL = URL(string: notificationImage){
                    
                    URLSession.shared.dataTask(with: imageURL) { data, response, error in
                        guard let data = data, error == nil else { return }
                        DispatchQueue.main.async { // execute on main thread
                           
                            self.notificationImageView.image = UIImage(data: data)
                        }
                    }.resume()
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
                        self.cardView.backgroundColor = cellStyle.backgroundColor.withAlphaComponent(0.6)
                    } else if status == "READ" {
                        let image = cellStyle.readButtonImage
                        self.readUnreadButton.setImage(image, for: .normal)
                        self.readUnreadButton.tintColor = cellStyle.readButtonImageTintColor
                        self.cardView.backgroundColor = cellStyle.backgroundColor.withAlphaComponent(1)
                    }
                }
            }
            
            self.cardView.layer.cornerRadius = cellStyle.cornerRadius
            self.cardView.layer.shadowColor = cellStyle.shadowColor.cgColor
            self.cardView.layer.shadowOffset = CGSize(width: cellStyle.shadow0ffSetWidth, height: cellStyle.shadow0ffSetHeight)
            self.cardView.layer.shadowOpacity = cellStyle.shadowOpacity
            self.deleteButton.setImage(cellStyle.deleteButtonImage, for: .normal)
            self.deleteButton.tintColor = cellStyle.deleteButtonImageTintColor
            self.notificationImageView.layer.cornerRadius = self.cellStyle.imageViewCornerRadius
            self.notificationImageView.image = nil
            self.notificationImageView.contentMode = cellStyle.imageViewContentMode
            self.contentView.backgroundColor = .init(white: 1.0, alpha: 0.9)
        }
    }
    
    func setupCustomConfiguration(customConfiguration: AnyObject){
        
        if let customConfig = customConfiguration as? WEPushCardConfigutationProtocol{
            cellStyle.cornerRadius = customConfig.cornerRadius
            cellStyle.shadowColor = customConfig.shadowColor
            cellStyle.shadow0ffSetWidth = customConfig.shadow0ffSetWidth
            cellStyle.shadow0ffSetWidth = customConfig.shadow0ffSetWidth
            cellStyle.shadowOpacity = customConfig.shadowOpacity
            cellStyle.backgroundColor = customConfig.backgroundColor
            cellStyle.imageViewCornerRadius = customConfig.cornerRadius
        }
        
        if let customConfig =  customConfiguration as? WEPushTextConfigurationProtocol{
            cellStyle.titleFont = customConfig.titleFont
            cellStyle.titleFontSize = customConfig.titleFontSize
            cellStyle.titleFontColor = customConfig.titleFontColor
            cellStyle.descriptionFont = customConfig.descriptionFont
            cellStyle.descriptionFontSize = customConfig.descriptionFontSize
            cellStyle.descriptionFontColor = customConfig.descriptionFontColor
            
            cellStyle.timeFont = customConfig.timeFont
            cellStyle.timeFontSize = customConfig.timeFontSize
            cellStyle.timeFontColor = customConfig.timeFontColor
            cellStyle.timeFormat = customConfig.timeFormat
            
            cellStyle.readButtonImage = customConfig.readButtonImage
            cellStyle.readButtonImageTintColor = customConfig.readButtonImageTintColor
            cellStyle.unReadButtonImage = customConfig.unReadButtonImage
            cellStyle.unReadButtonImageTintColor = customConfig.unReadButtonImageTintColor
            cellStyle.deleteButtonImage = customConfig.deleteButtonImage
            cellStyle.deleteButtonImageTintColor = customConfig.deleteButtonImageTintColor
            cellStyle.readUnreadButtonVisibility = customConfig.readUnreadButtonVisibility
            cellStyle.deleteButtonVisibility = customConfig.deleteButtonVisibility
        }
        
        if let customConfig =  customConfiguration as? WEPushBannerConfigurationProtocol{
            cellStyle.imageViewCornerRadius = customConfig.imageViewCornerRadius
            cellStyle.imageViewContentMode = customConfig.imageViewContentMode
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
                    self.cardView.backgroundColor = cellStyle.backgroundColor.withAlphaComponent(1)
                } else if datasource.status == "READ" {
                    delegate?.unreadEvent(datasource)
                    let image = cellStyle.unReadButtonImage
                    self.readUnreadButton.setImage(image, for: .normal)
                    self.readUnreadButton.tintColor = cellStyle.unReadButtonImageTintColor
                    self.datasource?.status = "UNREAD"
                    self.cardView.backgroundColor = cellStyle.backgroundColor.withAlphaComponent(0.6)
                }
            }
        }
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        delegate?.deleteEvent(datasource, sender: sender)
    }
}

