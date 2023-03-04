//
//  Network.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/04.
//

import Foundation
import Firebase

class Network {
    func uploadTweet(item: FridgeItemModel, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let data = item.asDictionary else {
            print("ERROR - asDictionary 디코딩 에러")
            return
        }
        DOC_USERS.document(uid).collection("item").document().setData(data) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
