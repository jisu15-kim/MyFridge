//
//  AIChatViewModel.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/02.
//

import Foundation

class AIChatViewModel {
    let storageType: KeepType
    let selectedItem: ItemType
    
    init(storageType: KeepType, selectedItem: ItemType) {
        self.storageType = storageType
        self.selectedItem = selectedItem
    }
    
    func makeKeyword() -> String {
        let text = "\(selectedItem.itemName)을 오래 \(storageType.rawValue)보관 하기 위한 효율적인 방법을 알려줘요"
        return text
    }
    
    func askToAI(keyword: String, completion: @escaping (String) -> Void) {
        AIManager().askRecommandStoreWay(keyword: keyword, completion: completion)
    }
}
