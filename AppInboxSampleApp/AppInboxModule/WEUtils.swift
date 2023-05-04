//
//  Utils.swift
//  AppInboxSampleApp
//
//  Created by Shubham Naidu on 28/04/23.
//

import Foundation

struct WEUtils{
    
    static func getAttributedString(rawString: String) -> NSAttributedString {
        var text:NSAttributedString = NSAttributedString()
        if let data = rawString.data(using: .utf8),
            let attribStr = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) {
                text = attribStr
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
