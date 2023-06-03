//
//  AppDelegate.swift
//  MyFridge
//
//  Created by 김지수 on 2023/02/28.
//

import UIKit
import KakaoSDKCommon
import FirebaseCore
import GoogleSignIn
import NaverThirdPartyLogin
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 카카오 로그인 활성화
        KakaoSDK.initSDK(appKey: Secret.kakaoAppID)
        
        // 네이버 로그인 활성화
        let naverLogin = NaverThirdPartyLoginConnection.getSharedInstance()
        naverLogin?.isNaverAppOauthEnable = true
        naverLogin?.isInAppOauthEnable = true
        naverLogin?.isOnlyPortraitSupportedInIphone()
        naverLogin?.serviceUrlScheme = kServiceAppUrlScheme
        naverLogin?.consumerKey = kConsumerKey
        naverLogin?.consumerSecret = kConsumerSecret
        naverLogin?.appName = kServiceAppName
        
        FirebaseApp.configure()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (isAllowed, error) in
            
        }
        
        ApiCallCounter.shared.resetAPICallCountIfNeeded()
        print(ApiCallCounter.shared.getAPICallCount())
        
        Thread.sleep(forTimeInterval: 1.0)    // 런치스크린 표시 시간 1초 강제 지연
        
        Secret.getAITokenFromFirebase()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
}

