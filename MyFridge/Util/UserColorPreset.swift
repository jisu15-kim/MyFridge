//
//  ColorManager.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/05.
//

import UIKit

enum UserColorPreset: String, CaseIterable, Codable {
    case smokyRose
    case appleGreen
    case turquoiseBlue
    case mustardYellow
    case lavender
    case cobaltBlue
    case brickRed
    case darkGreen
    case roseGold
    case navyBlue
    case ornage
    case purple
    case darkGray
    case limeGreen
    case lilac
    
    var color: UIColor {
        switch self {
        case .smokyRose:
            return UIColor.rgb(red: 192, green: 64, blue: 64)
        case .appleGreen:
            return UIColor.rgb(red: 141, green: 182, blue: 0)
        case .turquoiseBlue:
            return UIColor.rgb(red: 0, green: 199, blue: 183)
        case .mustardYellow:
            return UIColor.rgb(red: 238, green: 190, blue: 68)
        case .lavender:
            return UIColor.rgb(red: 181, green: 126, blue: 220)
        case .cobaltBlue:
            return UIColor.rgb(red: 0, green: 71, blue: 171)
        case .brickRed:
            return UIColor.rgb(red: 203, green: 65, blue: 84)
        case .darkGreen:
            return UIColor.rgb(red: 0, green: 100, blue: 0)
        case .roseGold:
            return UIColor.rgb(red: 183, green: 110, blue: 121)
        case .navyBlue:
            return UIColor.rgb(red: 0, green: 0, blue: 128)
        case .ornage:
            return UIColor.rgb(red: 255, green: 165, blue: 0)
        case .purple:
            return UIColor.rgb(red: 128, green: 0, blue: 128)
        case .darkGray:
            return UIColor.rgb(red: 64, green: 64, blue: 64)
        case .limeGreen:
            return UIColor.rgb(red: 50, green: 205, blue: 50)
        case .lilac:
            return UIColor.rgb(red: 200, green: 162, blue: 200)
        }
    }
}
