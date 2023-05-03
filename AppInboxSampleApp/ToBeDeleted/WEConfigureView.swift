//
//  ViewController.swift
//  AppInboxSampleApp
//
//  Created by Shubham Naidu on 24/04/23.
//


import Foundation
import UIKit
@IBDesignable class WEConfigureView : UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 6
    @IBInspectable var shadowColor : UIColor? = UIColor.purple
    @IBInspectable var shadow0ffSetWidth : Int = 0
    @IBInspectable var shadow0ffSetHeight : Int = 1
    @IBInspectable var shadowOpacity : Float = 0.3
    @IBInspectable var cardBackgroundColor: UIColor?
    @IBInspectable var readButtonImage: UIImage? = UIImage(systemName: "envelope.open")
    @IBInspectable var readButtonImageTintColor: UIColor?
    @IBInspectable var unReadButtonImage: UIImage? = UIImage(systemName: "envelope")
    @IBInspectable var unReadButtonImageTintColor: UIColor?
    @IBInspectable var deleteButtonImage: UIImage? = UIImage(systemName: "trash")
    @IBInspectable var deleteButtonImageTintColor: UIColor?
    @IBInspectable var cellHeight: CGFloat = 320
    
    override func  layoutSubviews () {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadow0ffSetWidth, height: shadow0ffSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = shadowOpacity
    }
    
    func updateCellHeight(height: CGFloat){
        cellHeight = height
    }

    func updateBackgroundColor(color: UIColor){
        cardBackgroundColor = color
    }
    func updateCornerRadius(radius: CGFloat){
        cornerRadius = radius
    }
    
    func updateShadowColor(color: UIColor){
        shadowColor = color
    }
    
    func updateShadow0ffSetwidth(width: Int){
        shadow0ffSetWidth = width
    }
    
    func updateShadow0ffSetHeight(height: Int){
        shadow0ffSetHeight = height
    }
    
    func updateShadowOpacity(opacity: Float){
        shadowOpacity = opacity
    }
    
    func updateReadButtonImage(systemName :String , color: UIColor){
        readButtonImage = UIImage(systemName: systemName)
        readButtonImageTintColor = color
    }
    
    func updateReadButtonImage(named: String, color: UIColor){
        readButtonImage = UIImage(named: named)
        readButtonImageTintColor = color
    }
    
    func updateUnReadButtonImage(systemName :String , color: UIColor){
        unReadButtonImage = UIImage(systemName: systemName)
        unReadButtonImageTintColor = color
    }
    
    func updateUnReadButtonImage(named: String, color: UIColor){
        unReadButtonImage = UIImage(named: named)
        unReadButtonImageTintColor = color
    }
    
    func updateDeleteButtonImage(systemName :String , color: UIColor){
        deleteButtonImage = UIImage(systemName: systemName)
        deleteButtonImageTintColor = color
    }
    
    func updateDeleteButtonImage(named: String, color: UIColor){
        deleteButtonImage = UIImage(named: named)
        deleteButtonImageTintColor = color
    }
}

protocol WEPushCell: NSObject {
    func imageViewSetup()
    func titleLabelSetup()
    func descriptionSetup()
    func readUnreadButtonSetup()
}
