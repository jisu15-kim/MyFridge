//
//  UserModel.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/12.
//

import Foundation

struct UserModel: Codable {
    enum LoginCase: Codable {
        case google
        case naver
        case kakao
        case apple
    }
    
    var email: String
    var password: String?
    var profileImage: URL
    var userName: String
    var loginCase: LoginCase
    
    var termsConfirmed: Bool? // 필수 동의 항목 체크 되었는지?
    var marketingConfirmed: Bool? // 마케팅 수신 동의 체크 되었는지?
}
