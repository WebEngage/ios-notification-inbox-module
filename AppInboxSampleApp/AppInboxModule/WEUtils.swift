//
//  Utils.swift
//  AppInboxSampleApp
//
//  Created by Shubham Naidu on 28/04/23.
//

import Foundation
import UIKit

struct WEUtils{
    
    static func getAttributedString(rawString: String,forLabelType: labelType, withSize size: CGFloat, withFont fontFamily: String, withColor color: UIColor) -> NSAttributedString {
        var text:NSAttributedString = NSAttributedString()
        var newFont: UIFont
        var newAttributes: [NSAttributedString.Key: Any]
        if let data = rawString.data(using: .utf8),
           let attribStr = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) {
            let updatedText = NSMutableAttributedString(attributedString: attribStr)
            for i in 0..<attribStr.length {
                let currentAttributes = attribStr.attributes(at: i, effectiveRange: nil)
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
                updatedText.addAttributes(newAttributes, range: NSRange(location: i, length: 1))
                text = updatedText
            }
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
            if let cornerRadius = customConfig.cornerRadius {
                cellStyle.cornerRadius = cornerRadius
            }
            if let shadowColor = customConfig.shadowColor {
                cellStyle.shadowColor = shadowColor
            }

            if let shadowOffsetWidth = customConfig.shadow0ffSetWidth {
                cellStyle.shadow0ffSetWidth = shadowOffsetWidth
            }

            if let shadowOffsetHeight = customConfig.shadow0ffSetHeight {
                cellStyle.shadow0ffSetHeight = shadowOffsetHeight
            }

            if let shadowOpacity = customConfig.shadowOpacity {
                cellStyle.shadowOpacity = shadowOpacity
            }

            if let cardBackgroundColor = customConfig.cardBackgroundColor {
                cellStyle.cardBackgroundColor = cardBackgroundColor
            }
        }
        
        if let customConfig =  customConfiguration as? WEPushTextConfigurationProtocol{
            if let titleFont = customConfig.titleFont {
                cellStyle.titleFont = titleFont
            }

            if let titleFontSize = customConfig.titleFontSize {
                cellStyle.titleFontSize = titleFontSize
            }

            if let titleFontColor = customConfig.titleFontColor {
                cellStyle.titleFontColor = titleFontColor
            }

            if let descriptionFont = customConfig.descriptionFont {
                cellStyle.descriptionFont = descriptionFont
            }

            if let descriptionFontSize = customConfig.descriptionFontSize {
                cellStyle.descriptionFontSize = descriptionFontSize
            }

            if let descriptionFontColor = customConfig.descriptionFontColor {
                cellStyle.descriptionFontColor = descriptionFontColor
            }

            if let timeFont = customConfig.timeFont {
                cellStyle.timeFont = timeFont
            }

            if let timeFontSize = customConfig.timeFontSize {
                cellStyle.timeFontSize = timeFontSize
            }

            if let timeFontColor = customConfig.timeFontColor {
                cellStyle.timeFontColor = timeFontColor
            }

            if let timeFormat = customConfig.timeFormat {
                cellStyle.timeFormat = timeFormat
            }

            if let readButtonImage = customConfig.readButtonImage {
                cellStyle.readButtonImage = readButtonImage
            }

            if let readButtonImageTintColor = customConfig.readButtonImageTintColor {
                cellStyle.readButtonImageTintColor = readButtonImageTintColor
            }

            if let unReadButtonImage = customConfig.unReadButtonImage {
                cellStyle.unReadButtonImage = unReadButtonImage
            }

            if let unReadButtonImageTintColor = customConfig.unReadButtonImageTintColor {
                cellStyle.unReadButtonImageTintColor = unReadButtonImageTintColor
            }

            if let deleteButtonImage = customConfig.deleteButtonImage {
                cellStyle.deleteButtonImage = deleteButtonImage
            }

            if let deleteButtonImageTintColor = customConfig.deleteButtonImageTintColor {
                cellStyle.deleteButtonImageTintColor = deleteButtonImageTintColor
            }

            if let readUnreadButtonVisibility = customConfig.readUnreadButtonVisibility {
                cellStyle.readUnreadButtonVisibility = readUnreadButtonVisibility
            }

            if let deleteButtonVisibility = customConfig.deleteButtonVisibility {
                cellStyle.deleteButtonVisibility = deleteButtonVisibility
            }

        }
        
        if let customConfig =  customConfiguration as? WEPushBannerConfigurationProtocol{
            if let imageViewCornerRadius = customConfig.imageViewCornerRadius {
                cellStyle.imageViewCornerRadius = imageViewCornerRadius
            }

            if let imageViewContentMode = customConfig.imageViewContentMode {
                cellStyle.imageViewContentMode = imageViewContentMode
            }
        }
        return cellStyle
    }
}
