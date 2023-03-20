//
//  FirebaseLoginManager.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/12.
//

import Foundation
import Firebase

class FirebaseLoginManager {
    
    // 카카오 / 네이버의 파이어베이스 로긩ㄴ 시도
    func tryFirebaseAuth(withUser user: UserModel, completion: @escaping (_ isSuccess: Bool) -> Void) {
        print(#function)
        print("로그인 시도")
        // 로그인 시도
        self.tryFirebaseLogin(withUser: user) { isSuccess in
            // 로그인 성공
            if isSuccess == true {
                completion(true)
            } else {
                // 로그인 실패 -> 회원등록
                self.tryFirebaseRegister(withUser: user) { isRegistered in
                    if isRegistered == true {
                        // 회원등록 성공시 다시 로그인 시도
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
    
    // 파이어베이스 로그인
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
    
    // Firebase Auth Create User
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
    
    // 유저 모델을 업데이트
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
    
    // 유저 Confirm 항목을 업데이트
    func userConfirmUpdate(uid: String, user: UserModel, completion: @escaping (Bool) -> Void) {
        guard let data = user.asDictionary else {
            print("디코딩 실패")
            completion(false)
            return
        }
        
        DOC_USERS.document(uid).updateData(data) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func googleAppleTryAuth(uid: String, user: UserModel, completion: @escaping (Bool) -> Void) {
        guard let data = user.asDictionary else {
            print("디코딩 실패")
            completion(false)
            return
        }
        
        DOC_USERS.document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("DEBUG - Error : \(error.localizedDescription)")
            } else {
                if snapshot?.exists == true {
                    DOC_USERS.document(uid).updateData(data) { error in
                        if let error = error {
                            print(error.localizedDescription)
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                } else {
                    DOC_USERS.document(uid).setData(data) { error in
                        if let error = error {
                            print(error.localizedDescription)
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                }
            }
        }
    }
}
