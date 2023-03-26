//
//  UserDefaults.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/26.
//

import Foundation

extension UserDefaults {
    func setthisAccoutFirstLogin(value: Bool) {
        UserDefaults.standard.set(value, forKey: "ThisAccoutFirstLogin")
    }
}
