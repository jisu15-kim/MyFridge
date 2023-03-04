//
//  FridgeItemModel.swift
//  MyFridge
//
//  Created by 김지수 on 2023/02/28.
//

import Foundation

struct FridgeItemConfig {
    var itemName: String
    var expireDay: Int
    var memo: String?
    var color: String
    var keepType: KeepType
    var itemType: ItemType
}

struct FridgeItemModel: Codable {
    var itemName: String
    var expireDay: Int
    var memo: String?
    var color: String
    var timestamp: Date
    var keepType: KeepType
    var category: Category
    var itemType: ItemType
    
    init(config: FridgeItemConfig) {
        self.itemName = config.itemName
        self.expireDay = config.expireDay
        self.memo = config.memo
        self.color = config.color
        self.itemType = config.itemType
        self.category = Category.allCases[itemType.id]
        self.keepType = config.keepType
        self.timestamp = Date()
    }
}

struct ItemTypeModel {
    var type: Category
}

enum KeepType: String, Codable {
    case fridge = "냉장"
    case freezer = "냉동"
}

enum Category: String, CaseIterable, Codable {
    case green
    case fruit
    case fish
    case meat
    case milk
    
    var categoryName: String {
        switch self {
        case .green: return "야채"
        case .fruit: return "과일"
        case .fish: return "생선"
        case .meat: return "육류"
        case .milk: return "유제품"
        }
    }
    
    var categoryId: Int {
        switch self {
        case .green:
            return 0
        case .fruit:
            return 1
        case .fish:
            return 2
        case .meat:
            return 3
        case .milk:
            return 4
        }
    }
}

enum ItemType: String, CaseIterable, Codable {
    // 채소
    case Asparagus
    case Eggplant
    case Brocoli
    case Cabbage
    case Pumpkin
    case Lettuce
    case Corn
    case Carrot
    case Pepper
    case Garlic
    case Chili
    case Cucumber
    case Onion
    case Potato
    case Tomato
    case Spinach
    
    // 과일
    case Apple
    case Orange
    case Banana
    case Melon
    case Watermelon
    case Strawberry
    case Pineapple
    case Avocado
    case Kiwi
    case Mango
    case Grape
    
    var itemName: String {
        switch self {
        // 채소
        case .Asparagus:
            return "아스파라거스"
        case .Eggplant:
            return "가지"
        case .Brocoli:
            return "브로콜리"
        case .Cabbage:
            return "양배추"
        case .Pumpkin:
            return "호박"
        case .Lettuce:
            return "상추"
        case .Corn:
            return "옥수수"
        case .Carrot:
            return "당근"
        case .Pepper:
            return "고추"
        case .Garlic:
            return "마늘"
        case .Chili:
            return "고추"
        case .Cucumber:
            return "오이"
        case .Onion:
            return "양파"
        case .Potato:
            return "감자"
        case .Tomato:
            return "토마토"
        case .Spinach:
            return "시금치"
            
        // 사과
        case .Apple:
            return "사과"
        case .Orange:
            return "오렌지"
        case .Banana:
            return "바나나"
        case .Melon:
            return "메론"
        case .Watermelon:
            return "수박"
        case .Strawberry:
            return "딸기"
        case .Pineapple:
            return "파인애플"
        case .Avocado:
            return "아보카도"
        case .Kiwi:
            return "키위"
        case .Mango:
            return "망고"
        case .Grape:
            return "포도"
        }
    }
    
    var id: Int {
        switch self {
        case .Asparagus, .Eggplant, .Brocoli, .Cabbage, .Pumpkin, .Lettuce, .Corn, .Pepper, .Garlic, .Chili, .Cucumber, .Onion, .Tomato, .Spinach, .Carrot, .Potato:
            return 0
        case .Apple, .Orange, .Banana, .Melon, .Watermelon, .Strawberry, .Pineapple, .Avocado, .Kiwi, .Mango, .Grape:
            return 1
        }
    }
}

enum FruitItemType: String, CaseIterable {
    case Apple
    case Orange
    case Banana
    case Melon
    case Watermelon
    case Strawberry
    case Pineapple
    case Avocado
    case Kiwi
    case Mango
    case Grape
    
    var itemName: String {
        switch self {
        case .Apple:
            return "사과"
        case .Orange:
            return "오렌지"
        case .Banana:
            return "바나나"
        case .Melon:
            return "메론"
        case .Watermelon:
            return "수박"
        case .Strawberry:
            return "딸기"
        case .Pineapple:
            return "파인애플"
        case .Avocado:
            return "아보카도"
        case .Kiwi:
            return "키위"
        case .Mango:
            return "망고"
        case .Grape:
            return "포도"
        }
    }
}
