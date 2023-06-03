//
//  AppConfigure.swift
//  MyFridge
//
//  Created by 김지수 on 2023/04/08.
//

import UIKit
import Alamofire

// app version 확인, 앱 업데이트 관련
//
struct AppStoreLookupResponse: Codable {
    let resultCount: Int
    let results: [AppStoreLookupResult]
}

struct AppStoreLookupResult: Codable {
    let version: String
}

struct AppConfiguration {
    static var needUpdate: Bool? = nil
    // 현재 버전 정보 : 타겟 -> 일반 -> Version
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
//    static let appVersion = "0.0.0"
    // 개발자가 내부적으로 확인하기 위한 용도 : 타겟 -> 일반 -> Build
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    
    static let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/\(Secret.appID)"
    
    // 앱 스토어 최신 정보 확인
    //
    func latestVersion(completion: @escaping (String?) -> Void) {
        let appleID = Secret.appID
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(appleID)&country=kr") else { return }
        
        AF.request(url).responseDecodable(of: AppStoreLookupResponse.self) { response in
            switch response.result {
            case .success(let lookupResponse):
                if lookupResponse.resultCount > 0 {
                    let version = lookupResponse.results[0].version
                    completion(version)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
    
    // 앱 스토어로 이동 -> urlStr 에 appStoreOpenUrlString 넣으면 이동
    func openAppStore() {
        guard let url = URL(string: AppConfiguration.appStoreOpenUrlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
