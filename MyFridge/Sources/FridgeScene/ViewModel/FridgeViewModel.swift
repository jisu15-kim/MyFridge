//
//  FridgeViewModel.swift
//  MyFridge
//
//  Created by 김지수 on 2023/02/28.
//

import UIKit
import Combine
import Firebase

class FridgeViewModel {
    //MARK: - Properties
    var items: CurrentValueSubject<[FridgeItemModel], Never>
    var user: CurrentValueSubject<UserModel?, Never>
    var selectedItem = CurrentValueSubject<[FridgeItemModel], Never>([])
    
    //MARK: - LifeCycle
    init() {
        items = CurrentValueSubject([])
        user = CurrentValueSubject(nil)
        fetchUser()
    }
    
    //MARK: - API
    func fetchUser() {
        Network().fetchUser { [weak self] user in
            self?.user.send(user)
        }
    }
    
    // 아이템 불러오기
    func fetchItems(completion: (() -> Void)? = nil) {
        Network().fetchMyItmes { [weak self] items in
            // 유통기한 순으로 정렬 후 send
            let sortedItem = items.sorted {
                $0.expireDay < $1.expireDay
            }
            self?.items.send(sortedItem)
        }
    }
    
    //MARK: - Helper
    
}
