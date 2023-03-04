//
//  Network.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/04.
//

import Foundation
import Firebase

class Network {
    
    func fetchMyItmes(completion: @escaping ([FridgeItemModel]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        DOC_USERS.document(uid).collection("item").getDocuments { (snapshot, error) in
            if let error = error {
                print(error)
            } else {
                guard let documents = snapshot?.documents else { return }
                var items: [FridgeItemModel] = []
                let decoder = JSONDecoder()
                for document in documents {
                    do {
                        let data = document.data()
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let item = try decoder.decode(FridgeItemModel.self, from: jsonData)
                        items.append(item)
                    } catch let error {
                        print("ERROR - \(error.localizedDescription)")
                    }
                }
                completion(items)
            }
        }
    }
    
    func uploadItem(item: FridgeItemModel, completion: @escaping(Bool) -> Void) {
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
