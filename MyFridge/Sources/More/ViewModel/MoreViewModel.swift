//
//  PreferenceViewModel.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/20.
//

import Foundation

enum MoreViewConfigureationType: String, CaseIterable {
    case notice = "공지사항"
    case terms = "이용약관"
    case privacyPolicy = "개인정보처리방침"
    case inquiry = "개선/보완 문의"
    case setting = "설정"
}

class MoreViewModel {
    //MARK: - Properties
    var user: UserModel
    
    //MARK: - Lifecycle
    init(user: UserModel) {
        self.user = user
    }
    
    //MARK: - Functions
}
