//
//  WEPushCell.swift
//  AppInboxSampleApp
//
//  Created by Shubham Naidu on 28/04/23.
//

import Foundation

protocol WEPushCellProtocol {
    var cornerRadius: CGFloat {get set}
    var shadowColor : UIColor {get set}
    var shadow0ffSetWidth : Int {get set}
    var shadow0ffSetHeight : Int {get set}
    var shadowOpacity : Float {get set}
    var cardBackgroundColor: UIColor {get set}
    var readButtonImage: UIImage {get set}
    var readButtonImageTintColor: UIColor {get set}
    var unReadButtonImage: UIImage {get set}
    var unReadButtonImageTintColor: UIColor {get set}
    var deleteButtonImage: UIImage {get set}
    var deleteButtonImageTintColor: UIColor {get set}
    
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

class DefaultTableViewCell: WEPushCellProtocol{
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

extension WEPushCellProtocol {
    
   
}
