//
//  AIChatViewModel.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/02.
//

import Foundation

class AIChatViewModel {
    enum AskType {
        case keep
        case recipe
    }
    
    //MARK: - Properties
    let askType: AskType
    let storageType: KeepType
    let selectedItem: ItemType
    
    //MARK: - Lifecycle
    init(storageType: KeepType, selectedItem: ItemType, askType: AskType) {
        self.storageType = storageType
        self.selectedItem = selectedItem
        self.askType = askType
    }
    
    //MARK: - Helper
    func makeKeyword() -> String {
        switch askType {
        case .keep:
            return makeRecommandSelectedItemKeyword()
        case .recipe:
            return makeRecommandRecipeSelectedItemKeyword()
        }
    }
    
    // AI에게 물어볼 키워드 만듬
    func makeRecommandSelectedItemKeyword() -> String {
        let text = "\(selectedItem.itemName)을 오래 \(storageType.rawValue)보관 하기 위한 효율적인 방법을 알려줘요"
        return text
    }
    
    func makeRecommandRecipeSelectedItemKeyword() -> String {
        let text = "\(selectedItem.itemName)을 활용한 추천 요리와 레시피를 알려줘"
        return text
    }
    
    // AI API 통신 함수
    func askToAI(keyword: String, completion: @escaping (String) -> Void) {
        AIManager().askChatAIApi(keyword: keyword, completion: completion)
    }
}
