//
//  GoogleLoginManager.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/12.
//

import Foundation
import Firebase
import GoogleSignIn

class GoogleLoginManager {
    
    func tryGoogleLogin(viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { (result, error) in
            if let error = error {
                print("ERROR! \(error.localizedDescription)")
            } else {
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString else { return }
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
                
                // Firebase
                Auth.auth().signIn(with: credential) { (result, error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    } else {
                        guard let email = user.profile?.email,
                              let userName = user.profile?.name,
                              let profileImage = user.profile?.imageURL(withDimension: 100),
                              let uid = result?.user.uid else { return }
                        
                        let userModel = UserModel(email: email, profileImage: profileImage, userName: userName, loginCase: .google)
                        FirebaseLoginManager().googleAppleTryAuth(uid: uid, user: userModel, completion: completion)
                    }
                }
            }
        }
    }
    
    func tryGoogleLogout() {
        GIDSignIn.sharedInstance.signOut()
    }
}
