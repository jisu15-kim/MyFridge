//
//  FridgeViewModel.swift
//  MyFridge
//
//  Created by 김지수 on 2023/02/28.
//

import UIKit
import Combine

class FridgeViewModel {
    //MARK: - Properties
    var items: CurrentValueSubject<[FridgeItemModel], Never>
    
    //MARK: - LifeCycle
    init() {
        items = CurrentValueSubject([])
    }
    
    //MARK: - API
    
    // 아이템 불러오기
    func fetchItems() {
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
