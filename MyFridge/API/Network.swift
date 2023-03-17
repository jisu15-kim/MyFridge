//
//  Network.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/04.
//

import Foundation
import Firebase

class Network {
    
    func fetchUser(completion: @escaping (UserModel) -> Void) {
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            DOC_USERS.document(uid).getDocument { (snapshot, error) in
                if let error = error {
                    print("DEBUG - ERROR: \(error.localizedDescription)")
                } else {
                    guard let document = snapshot else { return }
                    let decoder = JSONDecoder()
                    do {
                        guard let data = document.data() else { return }
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let item = try decoder.decode(UserModel.self, from: jsonData)
                        completion(item)
                    } catch let error {
                        print("ERROR - \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
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
                        var item = try decoder.decode(FridgeItemModel.self, from: jsonData)
                        item.docID = document.documentID
                        items.append(item)
                    } catch let error {
                        print("ERROR - \(error.localizedDescription)")
                    }
                }
                completion(items)
            }
        }
    }
    
    func fetchSingleItem(itemID: String, completion: @escaping (FridgeItemModel) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        DOC_USERS.document(uid).collection("item").document(itemID).getDocument { (snapshot, error) in
            if let error = error {
                print(error)
            } else {
                guard let document = snapshot else { return }
                let decoder = JSONDecoder()
                do {
                    guard let data = document.data() else { return }
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    var item = try decoder.decode(FridgeItemModel.self, from: jsonData)
                    item.docID = document.documentID
                    completion(item)
                } catch let error {
                    print("ERROR - \(error.localizedDescription)")
                }
            }
        }
    }
    
    func itemCreateUpdate(item: FridgeItemModel, type: DetailRegisterController.ActionType, itemID: String? = nil,
                    completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let data = item.asDictionary else {
            print("ERROR - asDictionary 디코딩 에러")
            return
        }
        
        switch type {
        case .register:
            DOC_USERS.document(uid).collection("item").document().setData(data) { error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                } else {
                    completion(true)
                }
            }
        case.modify:
            guard let id = itemID else { return }
            DOC_USERS.document(uid).collection("item").document(id).updateData(data) { error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    func deleteItem(itemID: String, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        DOC_USERS.document(uid).collection("item").document(itemID).delete { error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // 각 아이템별 유통기한 업로드 코드
    func updateItemInfoData() {
        
        ItemType.allCases.forEach {
            let itemInfoModel = ItemInfoModel(itemName: $0.rawValue, expireFridgeDay: $0.expireFridgeDay, expireFreeerDay: $0.expireFreezerDay)
            guard let data = itemInfoModel.asDictionary else {
                print("ItemType Info 디코딩 실패")
                return
            }
            DOC_ITEMINFOS.document($0.rawValue).setData(data) { error in
                if let error = error {
                    print(error)
                } else {
                    print("itemInfo 업데이트 성공")
                }
            }
        }
    }
    
    func fetchItemInfo(itemType: ItemType, completion: @escaping (ItemInfoModel) -> Void) {
        DOC_ITEMINFOS.document(itemType.rawValue).getDocument { (snapshot, error) in
            if let error = error {
                print(error)
            } else {
                guard let document = snapshot else { return }
                let decoder = JSONDecoder()
                do {
                    guard let data = document.data() else { return }
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    let item = try decoder.decode(ItemInfoModel.self, from: jsonData)
                    completion(item)
                } catch let error {
                    print("ERROR - \(error.localizedDescription)")
                }
            }
        }
    }
}
