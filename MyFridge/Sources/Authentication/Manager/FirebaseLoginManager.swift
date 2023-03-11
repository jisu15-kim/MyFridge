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
        Auth.auth().signIn(withEmail: user.email, password: user.password) { (result, error) in
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
        Auth.auth().createUser(withEmail: user.email, password: user.password) { (result, error) in
            if let error = error {
                print("DEBUG - Error is \(error.localizedDescription)")
            } else {
                guard let uid = result?.user.uid else { return }
                
                let values = ["email": user.email,
                              "profileUrl": "\(user.profileImage)",
                              "userName": user.userName]
                
                // User UID로 DB에 업데이트
                DOC_USERS.document(uid).setData(values) { error in
                    if let error = error {
                        print("DEBUG: Error is \(error.localizedDescription)")
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }
        }
    }
}
