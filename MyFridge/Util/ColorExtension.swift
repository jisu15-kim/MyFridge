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
    
    static let appLightAccent = UIColor.rgb(red: 102, green: 102, blue: 255)
    static let appDarkAccent = UIColor.rgb(red: 153, green: 153, blue: 255)
    
    static let appMainTint = UIColor.rgb(red: 130, green: 217, blue: 217)
    static let appMainSub = UIColor.rgb(red: 102, green: 0, blue: 255)
    static let appMainWhite = UIColor.rgb(red: 240, green: 242, blue: 242)
    static let appMainBlack = UIColor.rgb(red: 1, green: 3, blue: 38)
    
    static let appBackground = dynamicColor(lightColor: appMainWhite, darkColor: appMainBlack)
    static let appTint = dynamicColor(lightColor: appMainTint, darkColor: appMainSub)
    
    static let mainGrayBackground = dynamicColor(lightColor: .systemGray5, darkColor: .black)
    static let mainForeGround = dynamicColor(lightColor: .black, darkColor: .white)
    static let mainReverseLabel = dynamicColor(lightColor: .white, darkColor: .systemGray6)
    
    static let mainAccent = dynamicColor(lightColor: .appLightAccent, darkColor: .appLightAccent)
}

extension UIColor {
    static func dynamicColor(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? darkColor : lightColor
        }
    }
}
