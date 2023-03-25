//
//  AIChatViewModel.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/02.
//

import Foundation
import Combine

class AIChatViewModel {
    enum AskType {
        case keep
        case recipe
    }
    
    //MARK: - Properties
    let askType: AskType
    let storageType: KeepType
    let selectedItem: ItemType
    var recommandDishesModel: [FridgeItemModel]?
    var isAIProcessing: CurrentValueSubject<Bool, Never>
    var chats: CurrentValueSubject<[AIChatModel], Never>
    
    var askKeyword: String {
        return makeKeyword()
    }

    //MARK: - Lifecycle
    init(storageType: KeepType, selectedItem: ItemType, askType: AskType) {
        self.storageType = storageType
        self.selectedItem = selectedItem
        self.askType = askType
        self.isAIProcessing = CurrentValueSubject(false)
        let firstAIModel = AIChatModel(content: "안녕하세요✋ 무엇을 도와드릴까요?", chatType: .greeting)
        self.chats = CurrentValueSubject([])
        chats.value.append(firstAIModel)
    }
    
    convenience init(items: [FridgeItemModel]) {
        self.init(storageType: .fridge, selectedItem: .Apple, askType: .keep)
        self.recommandDishesModel = items
    }
    
    //MARK: - Selector
    @objc private func handleProcessing() {
        
    }
    
    //MARK: - Helper
    func setupKeyword() {
        
        if let itemModel = recommandDishesModel {
            if itemModel.count > 0 {
                let chat = AIChatModel(content: makeRecommandDishesWithSelectedItem(), chatType: .my)
                chats.value.append(chat)
                askToAI(keyword: makeRecommandDishesWithSelectedItem()) { _ in }
            }
        } else {
            let chat = AIChatModel(content: makeKeyword(), chatType: .my)
            chats.value.append(chat)
            askToAI(keyword: makeKeyword()) { _ in }
        }
    }
    
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
        let text = "\(selectedItem.itemName)을 \(storageType.rawValue)실에 보관하는 좋은 방법을 알려줘"
        return text
    }
    
    func makeRecommandRecipeSelectedItemKeyword() -> String {
        let text = "\(selectedItem.itemName)을 활용한 추천 요리와 레시피를 알려줘"
        return text
    }
    
    func makeRecommandDishesWithSelectedItem() -> String {
        var keyword = ""
        guard let models = recommandDishesModel else { return "" }
        models.enumerated().forEach {
            if models.count == $0 + 1 {
                keyword += "\($1.itemType.itemName)"
            } else {
                keyword += "\($1.itemType.itemName), "
            }
        }
        
        return "\(keyword)을(를) 활용한 음식을 추천해줘"
    }
    
    // AI API 통신 함수
    func askToAI(keyword: String, completion: @escaping (Bool) -> Void) {
        isAIProcessing.send(true)
        AIManager().askChatAIApi(keyword: keyword) { [weak self] (isSuccess, data) in
            if isSuccess == true {
                self?.chats.value.append(AIChatModel(content: data, chatType: .ai))
                self?.isAIProcessing.send(false)
            } else {
                print("에러처리")
                self?.chats.value.append(AIChatModel(content: "데이터를 로드하지 못했어요🙏 다시 시도해주세요!", chatType: .ai))
                self?.isAIProcessing.send(false)
            }
        }
    }
    
    func startProcessing(isProcessing: Bool) -> IndexPath? {
        let index = IndexPath(row: chats.value.count - 1, section: 0)
        return index
    }
    
    func getChatsCount() -> Int {
        return chats.value.count
    }
    
    func getChatViewModel(indexPath: IndexPath) -> ChatBubbleCellViewModel {
        let vm = ChatBubbleCellViewModel(data: chats.value[indexPath.row])
        return vm
    }
}
