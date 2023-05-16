//
//  Utils.swift
//  AppInboxSampleApp
//
//  Created by Shubham Naidu on 28/04/23.
//

import Foundation

struct WEUtils{
    
    static func getAttributedString(rawString: String, withSize size: CGFloat, withFont fontFamily: String, withColor color: UIColor) -> NSAttributedString {
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
            if color != UIColor.black {
                newAttributes = [
                    .font: newFont,
                    .foregroundColor: color
                ]
            } else{
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
}
