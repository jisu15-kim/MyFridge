//
//  KakaoLogin.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/12.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser

class KakaoLoginManager {
    
    func tryKakaoLogin(completion: @escaping (UserModel) -> Void) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
//                    let token = oauthToken
                    self.fetchUser(completion: completion)
                }
            }
        }
        else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")

                    //do something
//                    let _ = oauthToken
                    self.fetchUser(completion: completion)
                }
            }
        }
    }
    
    private func fetchUser(completion: @escaping (UserModel) -> Void) {
        UserApi.shared.me(completion: { (user, error) in
            if let error = error {
                print("DEBUG - 카카오 유저를 불러오는데 실패했습니다. \(error)")
            } else {
                guard let user = user,
                      let kakaoAcount = user.kakaoAccount,
                      let email = kakaoAcount.email,
                      let profile = kakaoAcount.profile?.thumbnailImageUrl,
                      let userName = kakaoAcount.profile?.nickname,
                      let id = user.id else { return }
                
                let userModel = UserModel(email: email, password: "\(id)", profileImage: profile, userName: userName, loginCase: .kakao)
                completion(userModel)
            }
        })
    }
}
