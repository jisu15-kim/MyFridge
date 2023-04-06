//
//  NaverLoginManager.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/12.
//

import UIKit
import NaverThirdPartyLogin
import Alamofire

protocol NaverLoginManagerDelegate: AnyObject {
    func loginSuccessed()
}

class NaverLoginManager: NSObject {
    
    //네이버 사용자 정보를 받아올 구조체
    struct NaverLogin: Decodable {
        var resultcode: String
        var response: Response
        var message: String
        
        struct Response: Decodable {
            var id: String
            var nickname: String
            var profile_image: String
            var email: String
        }
    }
    
    var delegate: NaverLoginManagerDelegate?
    
    lazy var loginInstance: NaverThirdPartyLoginConnection? = {
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        instance?.delegate = self
        return instance
    }()
    
    func tryNaverLogin(completion: @escaping (UserModel) -> Void) {
        tryLogout()
        guard let naver = loginInstance else { return }
        if naver.isValidAccessTokenExpireTimeNow() == false {
            print("로그인 시도")
            naver.requestThirdPartyLogin()
            print("로그인 성공. 유저 정보 얻어올께요")
            GetUserInfo(completion: completion)
        } else {
            print("이미 로그인 되어있어요. 유저 정보 얻어올께요")
            GetUserInfo(completion: completion)
        }
    }
    
    func GetUserInfo(completion: @escaping (UserModel) -> Void) {
        
        guard let tokenType = loginInstance?.tokenType else {
            print("ERROR - tokenType")
            return
        }
        guard let accessToken = loginInstance?.accessToken else {
            print("ERROR - accessToken")
            return
        }
        
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        print("TokenType: \(tokenType)")
        print("AccessToken: \(accessToken)")
        
        let authorization = "\(tokenType) \(accessToken)"
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseDecodable(of: NaverLogin.self) { response in
            
            switch response.result {
            case .success(let loginData):
                let user = loginData.response
                let userInfoModel = UserModel(email: user.email, password: user.id, profileImage: URL(string: user.profile_image)!, userName: user.nickname, loginCase: .naver)
                FirebaseLoginManager().tryFirebaseAuth(withUser: userInfoModel) { isSuccess in
                    completion(userInfoModel)
                }
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    func tryLogout() {
        loginInstance?.requestDeleteToken()
    }
}

extension NaverLoginManager: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("로그인 성공")
        self.GetUserInfo { [weak self] user in
            FirebaseLoginManager().tryFirebaseAuth(withUser: user) { isSuccess in
                if isSuccess == true {
                    self?.delegate?.loginSuccessed()
                }
            }
        }
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print(#function)
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print(#function)
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print(#function)
        if let error = error {
            print(error)
        }
    }
}
