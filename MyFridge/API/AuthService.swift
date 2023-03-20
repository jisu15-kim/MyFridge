//
//  AuthService.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/24.
//

import UIKit
import Firebase
import FirebaseAuth

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping(Bool) -> Void) {
        
        let email = credentials.email
        let password = credentials.password
        let fullname = credentials.fullname
        let username = credentials.username
        
        // Firebase 로그인 Auth
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Error is \(error.localizedDescription)")
                return // 에러가 있으면 함수 종료
            }
            
            guard let uid = result?.user.uid else { return }
            
            let values = ["email" : email,
                          "username" : username,
                          "fullname" : fullname]
            
            // User의 UID로 DB에 업데이트하기
            DOC_USERS.document(uid).setData(values) { error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    func logUserOut(user: UserModel, completion: @escaping() -> Void) {
        do {
            try Auth.auth().signOut()
            
            switch user.loginCase {
            case .apple:
                break
            case .google:
                GoogleLoginManager().tryGoogleLogout()
            case .kakao:
                KakaoLoginManager().kakaoLogout()
            case .naver:
                NaverLoginManager().tryLogout()
            }
            completion()
        } catch let error {
            print("DEBUG: 로그아웃에 실패했어요 \(error)")
        }
    }
}
