//
//  WEPushCell.swift
//  AppInboxSampleApp
//
//  Created by Shubham Naidu on 28/04/23.
//

import Foundation

//protocol WEPushCellConfigurationProtocol {
//    var cornerRadius: CGFloat {get }
//    var shadowColor : UIColor {get }
//    var shadow0ffSetWidth : Int {get set}
//    var shadow0ffSetHeight : Int {get set}
//    var shadowOpacity : Float {get set}
//    var cardBackgroundColor: UIColor {get set}
//    var readButtonImage: UIImage {get set}
//    var readButtonImageTintColor: UIColor {get set}
//    var unReadButtonImage: UIImage {get set}
//    var unReadButtonImageTintColor: UIColor {get set}
//    var deleteButtonImage: UIImage {get set}
//    var deleteButtonImageTintColor: UIColor {get set}
//
//    var titleFont: String {get set}
//    var titleFontSize: CGFloat {get set}
//    var titleFontColor: UIColor {get set}
//
//    var descriptionFont: String {get set}
//    var descriptionFontSize: CGFloat {get set}
//    var descriptionFontColor: UIColor {get set}
//
//    var timeFont: String {get set}
//    var timeFontSize: CGFloat {get set}
//    var timeFontColor: UIColor {get set}
//
//    var imageViewCornerRadius: CGFloat {get set}
//}

protocol WEPushCardConfigutationProtocol {
    var cornerRadius: CGFloat {get }
    var shadowColor : UIColor {get }
    var shadow0ffSetWidth : Int {get set}
    var shadow0ffSetHeight : Int {get set}
    var shadowOpacity : Float {get set}
    var cardBackgroundColor: UIColor {get set}
}

protocol WEPushButtonConfigurationProtocol{
    var readButtonImage: UIImage {get set}
    var readButtonImageTintColor: UIColor {get set}
    var unReadButtonImage: UIImage {get set}
    var unReadButtonImageTintColor: UIColor {get set}
    var deleteButtonImage: UIImage {get set}
    var deleteButtonImageTintColor: UIColor {get set}
}

protocol WEPushLabelConfigurationProtocol {
    var titleFont: String {get set}
    var titleFontSize: CGFloat {get set}
    var titleFontColor: UIColor {get set}

    var descriptionFont: String {get set}
    var descriptionFontSize: CGFloat {get set}
    var descriptionFontColor: UIColor {get set}

    var timeFont: String {get set}
    var timeFontSize: CGFloat {get set}
    var timeFontColor: UIColor {get set}
}

protocol WEPushBannerConfigurationProtocol: WEPushLabelConfigurationProtocol  {
    var imageViewCornerRadius: CGFloat {get set}
}

protocol WEPushCellConfigurationProtocol: WEPushCardConfigutationProtocol,WEPushButtonConfigurationProtocol,WEPushLabelConfigurationProtocol,WEPushBannerConfigurationProtocol  {
    
}


//extension WEPushCellProtocol {
//
//
//    var cornerRadius: CGFloat{
//      return 6
//    }
//    var shadowColor: UIColor {
//      return .gray
//    }
//
//    var titleFontColor: UIColor {
//        get { return .black }
//        set { self.titleFontColor = newValue }
//    }
//
//    var descriptionFontColor: UIColor {
//        get { return .black }
//        set { self.descriptionFontColor = newValue }
//    }
//
//    var timeFontColor: UIColor {
//        get { return .tintColor }
//        set { self.timeFontColor = newValue }
//    }
//
//    var titleFont: String {
//        get { return "AndaleMono" }
//        set { self.titleFont = newValue }
//    }
//
//    var descriptionFont: String {
//        get { return "AndaleMono" }
//        set { self.descriptionFont = newValue }
//    }
//
//    var timeFont: String {
//        get { return "AndaleMono" }
//        set { self.timeFont = newValue }
//    }
//
//    var titleFontSize: CGFloat {
//        get { return 16 }
//        set { self.titleFontSize = newValue }
//    }
//
//    var descriptionFontSize: CGFloat {
//        get { return 14 }
//        set { self.descriptionFontSize = newValue }
//    }
//
//    var timeFontSize: CGFloat {
//        get { return 14 }
//        set { self.timeFontSize = newValue }
//    }
//
//    var shadowColor: UIColor {
//        get { return .gray }
//        set { self.shadowColor = newValue }
//    }
//
//    var shadow0ffSetWidth: Int {
//        get { return 0 }
//        set { self.shadow0ffSetWidth = newValue }
//    }
//
//    var shadow0ffSetHeight: Int {
//        get { return 1 }
//        set { self.shadow0ffSetHeight = newValue }
//    }
//
//    var shadowOpacity: Float {
//        get { return 0.3 }
//        set { self.shadowOpacity = newValue }
//    }
//
//    var cardBackgroundColor: UIColor {
//        get { return .white }
//        set { cardBackgroundColor =  newValue}
//    }
//    // TODO - Remove Forced Unwrapping
//    var readButtonImage: UIImage {
//        get {return  UIImage(systemName: "envelope.open")!}
//        set { self.readButtonImage = newValue }
//    }
//
//    var readButtonImageTintColor: UIColor {
//        get {return .tintColor}
//        set { self.readButtonImageTintColor = newValue }
//    }
//    // TODO - Remove Forced Unwrapping
//    var unReadButtonImage: UIImage {
//        get {return  UIImage(systemName: "envelope")!}
//        set { self.unReadButtonImage = newValue }
//    }
//
//    var unReadButtonImageTintColor: UIColor {
//        get {return .orange}
//        set { self.unReadButtonImageTintColor = newValue }
//    }
//    // TODO - Remove Forced Unwrapping
//    var deleteButtonImage: UIImage {
//        get {return UIImage(systemName: "trash")!}
//        set { self.deleteButtonImage = newValue }
//    }
//
//    var deleteButtonImageTintColor: UIColor {
//        get {return .red}
//        set { self.deleteButtonImageTintColor = newValue }
//    }
//
//}
//class DefaultCellConfiguration: WEPushCellProtocol{
//
//}

class DefaultCellConfiguration: WEPushCellConfigurationProtocol{
    var imageViewCornerRadius: CGFloat = 6
    
    var titleFontColor: UIColor = .black

    var descriptionFontColor: UIColor = .black

    var timeFontColor: UIColor = .tintColor

    var titleFont: String = "AndaleMono"

    var descriptionFont: String = "AndaleMono"

    var timeFont: String = "AndaleMono"

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
