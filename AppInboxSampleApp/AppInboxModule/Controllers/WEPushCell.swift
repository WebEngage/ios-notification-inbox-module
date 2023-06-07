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

@objc enum CellType: Int {
    case text
    case banner
    case rating
    case carousel
    
    var stringValue: String {
        switch self {
        case .text:
            return "TEXT"
        case .banner:
            return "BANNER"
        case .rating:
            return "RATING"
        case .carousel:
            return "CAROUSEL"
        }
    }
}

@objc enum customConfig: Int{
    case text
    case banner
    case viewController
}

enum labelType{
    case title
    case description
    case time
}

// MARK: - Protocols
protocol InboxCellDelegate: NSObject {
    func readEvent(_: WEInboxMessage?)
    func unreadEvent(_: WEInboxMessage?)
    func viewEvent(_: WEInboxMessage?)
    func clickEvent(_: WEInboxMessage?)
    func deleteEvent(_: WEInboxMessage?, sender: Any)
}

@objc protocol WEViewControllerConfigurationProtocol{
    @objc optional var backgroundColor: UIColor {get set}
    @objc optional var navigationBarColor: UIColor {get set}
    @objc optional var navigationBarTintColor: UIColor {get set}
    @objc optional var navigationTitle: String {get set}
    @objc optional var navigationTitleColor: UIColor {get set}
    @objc optional var noNotificationsView: UIView {get set}
    @objc optional var optionMenuImage: UIImage {get set}
    @objc optional var optionMenuTitles: [String] {get set}
}
@objc protocol WECustomCellProtocol{
    var cellReuseIdentifier : CellType {get set}
    func setupcell(inboxData: AnyObject, index: Int)
}

@objc protocol WEPushCardConfigutationProtocol {
    @objc optional var cardBackgroundColor: UIColor {get set}
    @objc optional var cornerRadius: CGFloat {get set}
    @objc optional var shadowColor : UIColor {get set}
    @objc optional var shadow0ffSetWidth : Int {get set}
    @objc optional var shadow0ffSetHeight : Int {get set}
    @objc optional var shadowOpacity : Float {get set}
}

@objc protocol WEPushTextConfigurationProtocol:WEPushCardConfigutationProtocol {
    @objc optional var titleFont: String {get set}
    @objc optional var titleFontSize: CGFloat {get set}
    @objc optional var titleFontColor: UIColor {get set}
    
    @objc optional var descriptionFont: String {get set}
    @objc optional var descriptionFontSize: CGFloat {get set}
    @objc optional var descriptionFontColor: UIColor {get set}
    
    @objc optional var timeFont: String {get set}
    @objc optional var timeFontSize: CGFloat {get set}
    @objc optional var timeFontColor: UIColor {get set}
    @objc optional var timeFormat: String {get set}
    
    @objc optional var readButtonImage: UIImage {get set}
    @objc optional var readButtonImageTintColor: UIColor {get set}
    
    @objc optional var unReadButtonImage: UIImage {get set}
    @objc optional var unReadButtonImageTintColor: UIColor {get set}
    
    @objc optional var deleteButtonImage: UIImage {get set}
    @objc optional var deleteButtonImageTintColor: UIColor {get set}
    
    @objc optional var readUnreadButtonVisibility: Bool {get set}
    @objc optional var deleteButtonVisibility: Bool {get set}
}

@objc protocol WEPushBannerConfigurationProtocol: WEPushTextConfigurationProtocol  {
    @objc optional var imageViewCornerRadius: CGFloat {get set}
    @objc optional var imageViewContentMode: UIView.ContentMode {get set}
}

@objc protocol WEPushConfigurationProtocol: WEPushCardConfigutationProtocol,WEPushTextConfigurationProtocol,WEPushBannerConfigurationProtocol,WEViewControllerConfigurationProtocol {
    
}

// MARK: - Extensions
extension WECustomCellProtocol{
    var cellReuseIdentifier: CellType{
        get{
            return .text
        }
        set {}
    }
}

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
    
    var optionMenuTitles: [String] {
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
            return .tintColor
        }
        set {}
    }
    var backgroundColor: UIColor {
        get {
            return .init(white: 1, alpha: 0.9)
        }
        set {}
    }
    var noNotificationsView: UIView {
        get {
            return UIView(frame: UIScreen.main.bounds)
        }
        set{}
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
            return .tintColor
        }
        set {}
    }
    
    var timeFormat: String {
        get {
            return ""
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
    // TODO - Remove Forced Unwrapping
    var readButtonImage: UIImage = UIImage(systemName: "envelope.open")!
    
    var readButtonImageTintColor: UIColor = .tintColor
    // TODO - Remove Forced Unwrapping
    var unReadButtonImage: UIImage = UIImage(systemName: "envelope")!
    
    var unReadButtonImageTintColor: UIColor = .orange
    // TODO - Remove Forced Unwrapping
    var deleteButtonImage: UIImage = UIImage(systemName: "trash")!
    
    var deleteButtonImageTintColor: UIColor = .red
    
    var imageViewCornerRadius: CGFloat = 6.0
    
    var noNotificationsView: UIView = UIView(frame: UIScreen.main.bounds)
}

