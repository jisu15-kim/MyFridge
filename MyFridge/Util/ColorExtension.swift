//
//  Colors.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/05.
//

import UIKit

// MARK: - UIColor
extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let appMainTint = UIColor.rgb(red: 130, green: 217, blue: 217)
    static let appMainSub = UIColor.rgb(red: 111, green: 191, blue: 191)
    static let appMainWhite = UIColor.rgb(red: 240, green: 242, blue: 242)
    static let appMainGray = UIColor.rgb(red: 57, green: 62, blue: 89)
    static let appMainBlack = UIColor.rgb(red: 1, green: 3, blue: 38)
    
    static let appBackground = dynamicColor(lightColor: appMainWhite, darkColor: appMainBlack)
    static let appTint = dynamicColor(lightColor: appMainTint, darkColor: appMainSub)
}

extension UIColor {
    static func dynamicColor(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? darkColor : lightColor
        }
    }
}
