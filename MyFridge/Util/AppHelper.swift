//
//  AppHelper.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/20.
//

import UIKit

struct AppHelper {
    static func getRootController() -> MainTabViewController? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        guard let window = windowScenes?.windows.first(where: { $0.isKeyWindow }) else { return nil }
        guard let tab = window.rootViewController as? MainTabViewController else { return nil }
        return tab
    }
}
