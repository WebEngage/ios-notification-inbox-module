//
//  WEDefaultCell.swift
//  AppInboxSampleApp
//
//  Created by Shubham Naidu on 08/06/23.
//

import Foundation
import UIKit

// ===== This class hold the default values for the WE cells. ===== 
class DefaultCellConfiguration: WEPushConfigurationProtocol{
    
    var timeFormat: String = ""
    
    var navigationTitleColor: UIColor = .black
    
    var optionMenuImage: UIImage = UIImage(systemName: "ellipsis.circle")!
    
    var navigationBarColor: UIColor = .white
    
    var navigationBarTintColor: UIColor = .tintColor
    
    var navigationTitle: String = "Notification-Inbox"
    
    var optionMenuTitles: [String] = ["Read All", "Bulk Delete"]
    
    var imageViewContentMode: UIView.ContentMode = .scaleAspectFill
    
    var backgroundColor: UIColor = .init(white: 1, alpha: 0.9)
    
    var readUnreadButtonVisibility: Bool = true
    
    var deleteButtonVisibility: Bool = true

    var titleFontColor: UIColor = .black
    
    var descriptionFontColor: UIColor = .black
    
    var timeFontColor: UIColor = .tintColor
    
    var titleFont: String = ""
    
    var descriptionFont: String = ""
    
    var timeFont: String = ""
    
    var titleFontSize: CGFloat = 16
    
    var descriptionFontSize: CGFloat = 14
    
    var timeFontSize: CGFloat = 14
    
    var cornerRadius: CGFloat = 6
    
    var shadowColor: UIColor = .gray
    
    var shadow0ffSetWidth: Int = 0
    
    var shadow0ffSetHeight: Int = 1
    
    var shadowOpacity: Float = 0.3
    
    var cardBackgroundColor: UIColor = .white
    
    var readButtonImage: UIImage = UIImage(systemName: "envelope.open")!
    
    var readButtonImageTintColor: UIColor = .tintColor
    
    var unReadButtonImage: UIImage = UIImage(systemName: "envelope")!
    
    var unReadButtonImageTintColor: UIColor = .orange
    
    var deleteButtonImage: UIImage = UIImage(systemName: "trash")!
    
    var deleteButtonImageTintColor: UIColor = .red
    
    var imageViewCornerRadius: CGFloat = 6.0
    
    var noNotificationsView: UIView = UIView(frame: UIScreen.main.bounds)
}
