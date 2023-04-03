//
//  SocialLoginType.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/18.
//

import UIKit

enum SocialLoginType: String, CaseIterable {
    case kakao
    case apple
    case google
    case naver
    
    //MARK: - 배경색
    var backgroundColor: UIColor {
        switch self {
        case .kakao:
            return #colorLiteral(red: 1, green: 0.9064806104, blue: 0.04500900954, alpha: 1)
        case .apple:
            return #colorLiteral(red: 0.004803932738, green: 0, blue: 0, alpha: 1)
        case .google:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .naver:
            return #colorLiteral(red: 0.1553452313, green: 0.8276190162, blue: 0.2948952317, alpha: 1)
        }
    }
    
    //MARK: - 텍스트 컬러
    var textColor: UIColor {
        switch self {
        case .kakao:
            return #colorLiteral(red: 0.2681294084, green: 0.2095203996, blue: 0.2063862383, alpha: 1)
        case .apple:
            return .white
        case .google:
            return #colorLiteral(red: 0.4627450705, green: 0.4627450705, blue: 0.4627450705, alpha: 1)
        case .naver:
            return .white
        }
    }
    
    //MARK: - 텍스트
    var title: String {
        switch self {
        case .kakao:
            return "카카오톡으로 계속하기"
        case .apple:
            return "Apple로 계속하기"
        case .google:
            return "Google로 계속하기"
        case .naver:
            return "네이버로 계속하기"
        }
    }
    
    //MARK: - 아이콘
    var iconImage: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
