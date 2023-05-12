//
//  WEPushCell.swift
//  AppInboxSampleApp
//
//  Created by Shubham Naidu on 28/04/23.
//

import Foundation
import UIKit
import WENotificationInbox

// MARK: - Enums

enum cellType: String {
    case text = "TEXT"
    case banner = "BANNER"
    case rating = "RATING"
    case carousel = "CAROUSEL"
}

enum customConfig{
    case text
    case banner
    case viewController
}

// MARK: - Protocols

protocol InboxCellDelegate: NSObject {
    func readEvent(_: WEInboxMessage?)
    func unreadEvent(_: WEInboxMessage?)
    func viewEvent(_: WEInboxMessage?)
    func clickEvent(_: WEInboxMessage?)
    func deleteEvent(_: WEInboxMessage?, sender: Any)
}

protocol WEViewControllerConfigurationProtocol{
    var navigationTitle:String {get set}
    var navigationTitleColor: UIColor {get set}
    var optionMenuItems: [String] {get set}
    var optionMenuImage: UIImage {get set}
    var navigationBarColor : UIColor {get set}
    var navigationBarTintColor: UIColor {get set}
    var backgroundColor: UIColor {get set}
}

protocol WECustomCellProtocol{
    var cellReuseIdentifier : cellType {get set}
    func setupcell(inboxData: AnyObject, index: Int)
}

protocol WEPushCardConfigutationProtocol {
    var cornerRadius: CGFloat {get set}
    var shadowColor : UIColor {get set}
    var shadow0ffSetWidth : Int {get set}
    var shadow0ffSetHeight : Int {get set}
    var shadowOpacity : Float {get set}
    var cardBackgroundColor: UIColor {get set}
}

protocol WEPushTextConfigurationProtocol:WEPushCardConfigutationProtocol {
    var titleFont: String {get set}
    var titleFontSize: CGFloat {get set}
    var titleFontColor: UIColor {get set}
    
    var descriptionFont: String {get set}
    var descriptionFontSize: CGFloat {get set}
    var descriptionFontColor: UIColor {get set}
    
    var timeFont: String {get set}
    var timeFontSize: CGFloat {get set}
    var timeFontColor: UIColor {get set}
    var timeFormat: String {get set}
    
    var readButtonImage: UIImage {get set}
    var readButtonImageTintColor: UIColor {get set}
    var unReadButtonImage: UIImage {get set}
    var unReadButtonImageTintColor: UIColor {get set}
    var deleteButtonImage: UIImage {get set}
    var deleteButtonImageTintColor: UIColor {get set}
    var readUnreadButtonVisibility: Bool {get set}
    var deleteButtonVisibility: Bool {get set}
}

protocol WEPushBannerConfigurationProtocol: WEPushTextConfigurationProtocol  {
    var imageViewCornerRadius: CGFloat {get set}
    var imageViewContentMode: UIView.ContentMode {get set}
}

protocol WEPushConfigurationProtocol: WEPushCardConfigutationProtocol,WEPushTextConfigurationProtocol,WEPushBannerConfigurationProtocol,WEViewControllerConfigurationProtocol {
    
}

// MARK: - Extensions

extension WEViewControllerConfigurationProtocol {
    var navigationTitle: String {
        get {
            return "Notification-Inbox"
        }
        set {}
    }
    
    var navigationTitleColor: UIColor {
        get {
            return .black
        }
        set {}
    }
    
    var optionMenuItems: [String] {
        get {
            return ["Read All","Bulk Delete"]
        }
        set {}
    }
    
    var optionMenuImage: UIImage {
        get {
            return UIImage(systemName: "ellipsis.circle")!
        }
        set {}
    }
    
    var navigationBarColor: UIColor {
        get {
            return .white
        }
        set {}
    }
    
    var navigationBarTintColor: UIColor {
        get {
            return .blue
        }
        set {}
    }
    var backgroundColor: UIColor {
        get {
            return .init(white: 0.9, alpha: 1.0)
        }
        set {}
    }
}

extension WEPushCardConfigutationProtocol{
    
    var cornerRadius: CGFloat {
        get {
            return 6.0  
        }
        set {}
    }
    
    var shadowColor : UIColor {
        get {
            return .gray
        }
        set {}
    }
    var shadow0ffSetWidth : Int {
        get {
            return 0
        }
        set {}
    }
    
    var shadow0ffSetHeight : Int {
        get {
            return 1
        }
        set {}
    }
    var shadowOpacity : Float {
        get {
            return 0.3
        }
        set {}
    }
    
    var cardBackgroundColor: UIColor {
        get {
            return .white
        }
        set {}
    }
    
    
}

extension WEPushTextConfigurationProtocol{
    var titleFont: String {
        get {
            return ""
        }
        set {}
    }
    
    var titleFontSize: CGFloat {
        get {
            return 16
        }
        set {}
    }
    
    var titleFontColor: UIColor {
        get {
            return .black
        }
        set {}
    }
    
    var descriptionFont: String {
        get {
            return ""
        }
        set {}
    }
    
    var descriptionFontSize: CGFloat {
        get {
            return 14
        }
        set {}
    }
    
    var descriptionFontColor: UIColor {
        get {
            return .black
        }
        set {}
    }
    
    var timeFont: String {
        get {
            return ""
        }
        set {}
    }
    
    var timeFontSize: CGFloat {
        get {
            return 14
        }
        set {}
    }
    
    var timeFontColor: UIColor {
        get {
            return .black
        }
        set {}
    }
    
    var timeFormat: String {
        get {
            return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        }
        set {}
    }
    
    var readButtonImage: UIImage {
        get {
            return UIImage(systemName: "envelope.open")!
        }
        set {}
    }
    
    var readButtonImageTintColor: UIColor {
        get {
            return .tintColor
        }
        set {}
    }
    
    var unReadButtonImage: UIImage {
        get {
            return UIImage(systemName: "envelope")!
        }
        set {}
    }
    
    var unReadButtonImageTintColor: UIColor {
        get {
            return .orange
        }
        set {}
    }
    
    var deleteButtonImage: UIImage {
        get {
            return UIImage(systemName: "trash")!
        }
        set {}
    }
    
    var deleteButtonImageTintColor: UIColor {
        get {
            return .red
        }
        set {}
    }
    
    var readUnreadButtonVisibility: Bool {
        get {
            return true
        }
        set {}
    }
    
    var deleteButtonVisibility: Bool {
        get {
            return true
        }
        set {}
    }
}

extension WEPushBannerConfigurationProtocol{
    var imageViewCornerRadius: CGFloat {
        get {
            return 6.0
        }
        set {}
    }
    
    var imageViewContentMode: UIView.ContentMode {
        get {
            return .scaleAspectFill
        }
        set {}
    }
}


// MARK: - Default Class

class DefaultCellConfiguration: WEPushConfigurationProtocol{
    
    var timeFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    var navigationTitleColor: UIColor = .black
    
    var optionMenuImage: UIImage = UIImage(systemName: "ellipsis.circle")!
    
    var navigationBarColor: UIColor = .white
    
    var navigationBarTintColor: UIColor = .tintColor
    
    var navigationTitle: String = "Notification-Inbox"
    
    var optionMenuItems: [String] = ["Read All", "Bulk Delete"]
    
    var imageViewContentMode: UIView.ContentMode = .scaleAspectFill
    
    var readUnreadButtonVisibility: Bool = true
    
    var deleteButtonVisibility: Bool = true
    
    var imageViewCornerRadius: CGFloat = 6
    
    var titleFontColor: UIColor = .black
    
    var descriptionFontColor: UIColor = .black
    
    var timeFontColor: UIColor = .black
    
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
    // TODO - Remove Forced Unwrapping
    var readButtonImage: UIImage = UIImage(systemName: "envelope.open")!
    
    var readButtonImageTintColor: UIColor = .tintColor
    // TODO - Remove Forced Unwrapping
    var unReadButtonImage: UIImage = UIImage(systemName: "envelope")!
    
    var unReadButtonImageTintColor: UIColor = .orange
    // TODO - Remove Forced Unwrapping
    var deleteButtonImage: UIImage = UIImage(systemName: "trash")!
    
    var deleteButtonImageTintColor: UIColor = .red
}

