//
//  Utils.swift
//  AppInboxSampleApp
//
//  Created by Shubham Naidu on 28/04/23.
//

import Foundation

struct WEUtils{
    
    static func getAttributedString(rawString: String,forLabelType: labelType, withSize size: CGFloat, withFont fontFamily: String, withColor color: UIColor) -> NSAttributedString {
        var text:NSAttributedString = NSAttributedString()
        var newFont: UIFont
        var newAttributes: [NSAttributedString.Key: Any]
        if let data = rawString.data(using: .utf8),
           let attribStr = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) {
            let currentAttributes = attribStr.attributes(at: 0, effectiveRange: nil)
            let font = currentAttributes[NSAttributedString.Key.font] as? UIFont ?? UIFont.systemFont(ofSize: size)
            if !fontFamily.isEmpty {
                newFont = UIFont(name: fontFamily, size: size) ?? font.withSize(size)
            }else{
                newFont = font.withSize(size)
            }
            if (color != UIColor.black && forLabelType != .time) || (forLabelType == .time) {
                newAttributes = [
                    .font: newFont,
                    .foregroundColor: color
                ]
            }else {
                newAttributes = [NSAttributedString.Key.font: newFont]
            }
            let updatedText = NSMutableAttributedString(attributedString: attribStr)
            updatedText.addAttributes(newAttributes, range: NSRange(location: 0, length: updatedText.length))
            text = updatedText
        }
        return text
    }

    static func getTimeAgo(notificationTime : String) -> String{
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        if let pastDate = dateFormatter.date(from:notificationTime) {
            if let timeAgo = formatter.string(from: pastDate, to: Date()){
                return timeAgo
            }
        }
        return "\(notificationTime)"
    }
    
    static func getTime(withFormat: String, forTime time: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: time) {
            dateFormatter.dateFormat = withFormat
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate.description
        }
        return time
    }
    
    static func setupCustomConfiguration(customConfiguration: AnyObject, cellStyle: DefaultCellConfiguration) -> DefaultCellConfiguration{
        
        if let customConfig = customConfiguration as? WEPushCardConfigutationProtocol{
            cellStyle.cornerRadius = customConfig.cornerRadius
            cellStyle.shadowColor = customConfig.shadowColor
            cellStyle.shadow0ffSetWidth = customConfig.shadow0ffSetWidth
            cellStyle.shadow0ffSetWidth = customConfig.shadow0ffSetWidth
            cellStyle.shadowOpacity = customConfig.shadowOpacity
            cellStyle.cardBackgroundColor = customConfig.cardBackgroundColor
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
        return cellStyle
    }
}
