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
    var items: CurrentValueSubject<[FridgeItemViewModel], Never>
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
            var itemViewModels: [FridgeItemViewModel] = []
            items.forEach { item in
                itemViewModels.append(FridgeItemViewModel(item: item))
            }
            // 아이템 뷰 모델 생성
            let sortedViewModel = itemViewModels.sorted {
                $0.item.expireDay < $1.item.expireDay
            }
            self?.items.send(sortedViewModel)
            self?.registerNotiAtFirstLogin(items: sortedViewModel)
        }
    }
    
    func registerNotiAtFirstLogin(items: [FridgeItemViewModel]) {
        let firstLogin = UserDefaults.standard.bool(forKey: "ThisAccoutFirstLogin")
        print("DEBUG - firstLogin: \(firstLogin)")
        if firstLogin == true {
            items.forEach { itemViewModel in
                itemViewModel.item.userNotiData.enumerated().forEach { (index, config) in
                    let calendar = Calendar.current
                    var dateComponents = calendar.dateComponents([.year, .month, .day], from: config.date)
                    dateComponents.hour = 18
                    NotificationManager().setItemNotification(withItemViewModel: itemViewModel, notiConfig: config, index: index, dateComponents: dateComponents)
                    UserDefaults.standard.setthisAccoutFirstLogin(value: false)
                }
            }
        }
        
    }
    
    //MARK: - Helper
    
}
