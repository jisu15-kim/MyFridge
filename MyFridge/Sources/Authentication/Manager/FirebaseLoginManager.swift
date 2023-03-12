//
//  FirebaseLoginManager.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/12.
//

import Foundation
import Firebase

class FirebaseLoginManager {
    
    func tryFirebaseAuth(withUser user: UserModel, completion: @escaping (_ isSuccess: Bool) -> Void) {
        print(#function)
        print("로그인 시도")
        // 로그인 시도
        self.tryFirebaseLogin(withUser: user) { isSuccess in
            if isSuccess == true {
                completion(true)
            } else {
                self.tryFirebaseRegister(withUser: user) { isRegistered in
                    if isRegistered == true {
                        self.tryFirebaseLogin(withUser: user) { isLogined in
                            if isLogined == true {
                                completion(true)
                            } else {
                                completion(false)
                            }
                        }
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
    
    private func tryFirebaseLogin(withUser user: UserModel, completion: @escaping (Bool) -> Void) {
        print(#function)
        guard let password = user.password else { return }
        Auth.auth().signIn(withEmail: user.email, password: password) { (result, error) in
            if let error = error {
                print("Error is \(error.localizedDescription)")
                completion(false)
                return
            } else {
                completion(true)
            }
        }
    }
    
    private func tryFirebaseRegister(withUser user: UserModel, completion: @escaping (Bool) -> Void) {
        print(#function)
        guard let password = user.password else { return }
        Auth.auth().createUser(withEmail: user.email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG - Error is \(error.localizedDescription)")
            } else {
                guard let uid = result?.user.uid else { return }
                self.updateUserFirestore(uid: uid, user: user, completion: completion)
            }
        }
    }
    
    func updateUserFirestore(uid: String, user: UserModel, completion: @escaping (Bool) -> Void) {
        print(#function)
        guard let data = user.asDictionary else {
            print("디코딩 실패")
            return
        }
//        let values = ["email": user.email,
//                      "profileUrl": "\(user.profileImage)",
//                      "userName": user.userName,
//                      "loginCase": user.loginCase] as [String : Any]
        
        // User UID로 DB에 업데이트
        DOC_USERS.document(uid).setData(data) { error in
            if let error = error {
                print("DEBUG: Error is \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
