//
//  WEPushCellProtocols.swift
//  AppInboxSampleApp
//
//  Created by Shubham Naidu on 28/04/23.
//

import Foundation
import UIKit
import WENotificationInbox

// MARK: - Protocols
// ===== To perform actions on cells =====
protocol InboxCellDelegate: NSObject {
    func readEvent(_: WEInboxMessage?)
    func unreadEvent(_: WEInboxMessage?)
    func viewEvent(_: WEInboxMessage?)
    func clickEvent(_: WEInboxMessage?)
    func deleteEvent(_: WEInboxMessage?, sender: Any)
}

// ===== This protocol is used to customize the View Controller =====
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
// ===== This Protocol is to create a customCell =====
@objc protocol WECustomCellProtocol{
    var cellReuseIdentifier : CellType {get set}
    func setupcell(inboxData: AnyObject, index: Int)
}

// ===== This protocol is used for customizing the WebEngage's Cells =====
@objc protocol WEPushCardConfigutationProtocol {
    @objc optional var cardBackgroundColor: UIColor {get set}
    @objc optional var cornerRadius: CGFloat {get set}
    @objc optional var shadowColor : UIColor {get set}
    @objc optional var shadow0ffSetWidth : Int {get set}
    @objc optional var shadow0ffSetHeight : Int {get set}
    @objc optional var shadowOpacity : Float {get set}
}
// ===== This protocol is used for customizing the WebEngage's Text Cells =====
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

// ===== This protocol is used for customizing the WebEngage's Banner Cells =====
@objc protocol WEPushBannerConfigurationProtocol: WEPushTextConfigurationProtocol  {
    @objc optional var imageViewCornerRadius: CGFloat {get set}
    @objc optional var imageViewContentMode: UIView.ContentMode {get set}
}

// ===== This protocol is used for customizing All the Properties at one place. =====
@objc protocol WEPushConfigurationProtocol: WEPushCardConfigutationProtocol,WEPushTextConfigurationProtocol,WEPushBannerConfigurationProtocol,WEViewControllerConfigurationProtocol {
    
}
