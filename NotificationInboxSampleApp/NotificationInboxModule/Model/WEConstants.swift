//
//  WEConstants.swift
//  AppInboxSampleApp
//
//  Created by Shubham Naidu on 08/06/23.
//

import Foundation

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
