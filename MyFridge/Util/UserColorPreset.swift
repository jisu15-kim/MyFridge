//
//  ColorManager.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/05.
//

import UIKit

//enum UserColorPreset: String, CaseIterable, Codable {
//    case smokyRose
//    case appleGreen
//    case turquoiseBlue
//    case mustardYellow
//    case lavender
//    case cobaltBlue
//    case brickRed
//    case darkGreen
//    case roseGold
//    case navyBlue
//    case ornage
//    case purple
//    case darkGray
//    case limeGreen
//    case lilac
//
//    var color: UIColor {
//        switch self {
//        case .smokyRose:
//            return UIColor.rgb(red: 192, green: 64, blue: 64)
//        case .appleGreen:
//            return UIColor.rgb(red: 141, green: 182, blue: 0)
//        case .turquoiseBlue:
//            return UIColor.rgb(red: 0, green: 199, blue: 183)
//        case .mustardYellow:
//            return UIColor.rgb(red: 238, green: 190, blue: 68)
//        case .lavender:
//            return UIColor.rgb(red: 181, green: 126, blue: 220)
//        case .cobaltBlue:
//            return UIColor.rgb(red: 0, green: 71, blue: 171)
//        case .brickRed:
//            return UIColor.rgb(red: 203, green: 65, blue: 84)
//        case .darkGreen:
//            return UIColor.rgb(red: 0, green: 100, blue: 0)
//        case .roseGold:
//            return UIColor.rgb(red: 183, green: 110, blue: 121)
//        case .navyBlue:
//            return UIColor.rgb(red: 0, green: 0, blue: 128)
//        case .ornage:
//            return UIColor.rgb(red: 255, green: 165, blue: 0)
//        case .purple:
//            return UIColor.rgb(red: 128, green: 0, blue: 128)
//        case .darkGray:
//            return UIColor.rgb(red: 64, green: 64, blue: 64)
//        case .limeGreen:
//            return UIColor.rgb(red: 50, green: 205, blue: 50)
//        case .lilac:
//            return UIColor.rgb(red: 200, green: 162, blue: 200)
//        }
//    }
//}

//enum UserColorPreset: String, CaseIterable, Codable {
//    case smokyRose
//    case appleGreen
//    case turquoiseBlue
//    case mustardYellow
//    case lavender
//    case cobaltBlue
//    case brickRed
//    case darkGreen
//    case roseGold
//    case navyBlue
//    case ornage
//    case purple
//    case darkGray
//    case limeGreen
//    case lilac
//
//    var color: UIColor {
//        switch self {
//        case .smokyRose:
//            return UIColor.rgb(red: 224, green: 168, blue: 172)
//        case .appleGreen:
//            return UIColor.rgb(red: 173, green: 210, blue: 158)
//        case .turquoiseBlue:
//            return UIColor.rgb(red: 163, green: 225, blue: 218)
//        case .mustardYellow:
//            return UIColor.rgb(red: 247, green: 220, blue: 111)
//        case .lavender:
//            return UIColor.rgb(red: 197, green: 168, blue: 224)
//        case .cobaltBlue:
//            return UIColor.rgb(red: 153, green: 183, blue: 221)
//        case .brickRed:
//            return UIColor.rgb(red: 207, green: 136, blue: 133)
//        case .darkGreen:
//            return UIColor.rgb(red: 113, green: 179, blue: 133)
//        case .roseGold:
//            return UIColor.rgb(red: 212, green: 167, blue: 161)
//        case .navyBlue:
//            return UIColor.rgb(red: 82, green: 108, blue: 144)
//        case .ornage:
//            return UIColor.rgb(red: 255, green: 181, blue: 108)
//        case .purple:
//            return UIColor.rgb(red: 192, green: 148, blue: 204)
//        case .darkGray:
//            return UIColor.rgb(red: 169, green: 169, blue: 169)
//        case .limeGreen:
//            return UIColor.rgb(red: 167, green: 218, blue: 118)
//        case .lilac:
//            return UIColor.rgb(red: 216, green: 191, blue: 216)
//        }
//    }
//}

enum UserColorPreset: String, CaseIterable, Codable {
    case babyBlue
    case mintGreen
    case peach
    case lavender
    case palePink
    case lightYellow
    case softOrange
    case pastelGreen
    case lightPurple
    case paleTurquoise
    case lightGray
    case powderBlue
    case paleGreen
    case salmonPink
    case lilac
    
    var color: UIColor {
        switch self {
        case .babyBlue:
            return UIColor(red: 137/255, green: 207/255, blue: 240/255, alpha: 1)
        case .mintGreen:
            return UIColor(red: 152/255, green: 255/255, blue: 152/255, alpha: 1)
        case .peach:
            return UIColor(red: 255/255, green: 218/255, blue: 185/255, alpha: 1)
        case .lavender:
            return UIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1)
        case .palePink:
            return UIColor(red: 250/255, green: 218/255, blue: 221/255, alpha: 1)
        case .lightYellow:
            return UIColor(red: 255/255, green: 255/255, blue: 224/255, alpha: 1)
        case .softOrange:
            return UIColor(red: 255/255, green: 218/255, blue: 185/255, alpha: 1)
        case .pastelGreen:
            return UIColor(red: 119/255, green: 221/255, blue: 119/255, alpha: 1)
        case .lightPurple:
            return UIColor(red: 216/255, green: 191/255, blue: 216/255, alpha: 1)
        case .paleTurquoise:
            return UIColor(red: 175/255, green: 238/255, blue: 238/255, alpha: 1)
        case .lightGray:
            return UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        case .powderBlue:
            return UIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1)
        case .paleGreen:
            return UIColor(red: 152/255, green: 251/255, blue: 152/255, alpha: 1)
        case .salmonPink:
            return UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)
        case .lilac:
            return UIColor(red: 200/255, green: 162/255, blue: 200/255, alpha: 1)
        }
    }
}
