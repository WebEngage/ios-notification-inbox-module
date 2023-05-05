//
//  WEPushCell.swift
//  AppInboxSampleApp
//
//  Created by Shubham Naidu on 28/04/23.
//

import Foundation

protocol WEViewControllerConfigurationProtocol{
    var navigationTitle:String {get set}
    var navigationTitleColor: UIColor {get set}
    var optionMenuItems: [String] {get set}
    var optionMenuImage: UIImage {get set}
    var navigationBarColor : UIColor {get set}
    var navigationBarTintColor: UIColor {get set}
}

protocol WEPushCardConfigutationProtocol {
    var cornerRadius: CGFloat {get set}
    var shadowColor : UIColor {get set}
    var shadow0ffSetWidth : Int {get set}
    var shadow0ffSetHeight : Int {get set}
    var shadowOpacity : Float {get set}
    var cardBackgroundColor: UIColor {get set}
}

protocol WEPushTextConfigurationProtocol {
    var titleFont: String {get set}
    var titleFontSize: CGFloat {get set}
    var titleFontColor: UIColor {get set}

    var descriptionFont: String {get set}
    var descriptionFontSize: CGFloat {get set}
    var descriptionFontColor: UIColor {get set}

    var timeFont: String {get set}
    var timeFontSize: CGFloat {get set}
    var timeFontColor: UIColor {get set}
    
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

class DefaultCellConfiguration: WEPushConfigurationProtocol{
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
}
