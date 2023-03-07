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
    var isAIProcessing: CurrentValueSubject<Bool, Never>
    var chats: CurrentValueSubject<[AIChatModel], Never>
    var processingTimer: Timer?
    
    var askKeyword: String {
        return makeKeyword()
    }

    //MARK: - Lifecycle
    init(storageType: KeepType, selectedItem: ItemType, askType: AskType) {
        self.storageType = storageType
        self.selectedItem = selectedItem
        self.askType = askType
        self.isAIProcessing = CurrentValueSubject(false)
        let firstAIModel = AIChatModel(content: "안녕하세요✋ 무엇을 도와드릴까요?", chatType: .ai)
        self.chats = CurrentValueSubject([])
        chats.value.append(firstAIModel)
        setupKeyword()
    }
    
    //MARK: - Selector
    @objc private func handleProcessing() {
        
    }
    
    //MARK: - Helper
    func setupKeyword() {
        let chat = AIChatModel(content: makeKeyword(), chatType: .my)
        chats.value.append(chat)
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
    
    // AI API 통신 함수
    func askToAI(keyword: String, completion: @escaping (Bool) -> Void) {
//        AIManager().askChatAIApi(keyword: keyword) { [weak self] data in
//            self?.chats.value.append(AIChatModel(content: data, chatType: .ai))
//            completion(true)
//        }
    }
    
    func bindAndReturnAIProcessingString(value: Bool) {
        let dots = ["●", "● ●", "● ● ●"]
        var index: Int = 0
        if value == true {
            if processingTimer?.isValid == false || processingTimer == nil {
                self.processingTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] _ in
                    guard let self = self else { return }
                    index = (index + 1) % dots.count
                    let processingString = dots[index]
                    let processingModel = AIChatModel(content: processingString, chatType: .processing)
                    
                    // Processing Chat이 이미 존재한다면 - 마지막 배열 요소 텍스트 수정
                    if self.chats.value.contains(where: { $0.chatType == .processing }) == true {
                        self.chats.value[self.chats.value.count - 1].content = processingString
                    }
                    
                    // Processing Chat이 없다면 (초기) - 배열에 추가
                    else {
                        self.chats.value.append(processingModel)
                    }
                    
                })
            }
        } else {
            guard let timer = processingTimer else { return }
            timer.invalidate()
        }
    }
    
    func getChatsCount() -> Int {
        return chats.value.count
    }
    
    func getChatViewModel(indexPath: IndexPath) -> ChatBubbleCellViewModel {
        let vm = ChatBubbleCellViewModel(data: chats.value[indexPath.row])
        return vm
    }
}
