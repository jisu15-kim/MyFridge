//
//  UserModel.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/12.
//

import Foundation

struct UserModel: Codable {
    var email: String
    var password: String
    var profileImage: URL
    var userName: String
}
