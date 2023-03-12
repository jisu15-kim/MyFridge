//
//  FridgeItemModel.swift
//  MyFridge
//
//  Created by 김지수 on 2023/02/28.
//

import UIKit

struct FridgeItemConfig {
    var itemName: String
    var expireDay: Int
    var memo: String?
    var color: UserColorPreset
    var keepType: KeepType
    var itemType: ItemType
    var userNoti: [ItemNotiConfig]
}

struct FridgeItemModel: Codable {
    var docID: String?
    var userNotiData: [ItemNotiConfig]
    var itemName: String
    var expireDay: Int
    var memo: String?
    var color: UserColorPreset
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
        self.userNotiData = config.userNoti
        self.timestamp = Date()
    }
}

struct ItemNotiConfig: Codable {
    var date: Date
    var dayOffset: Int
    var uid: String
}

struct ItemTypeModel {
    var type: Category
}

enum KeepType: String, CaseIterable, Codable {
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
        case .fish: return "해물"
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
        case .meat:
            return 2
        case .fish:
            return 3
        case .milk:
            return 4
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .green:
            return UIColor.rgb(red: 0, green: 30, blue: 128)
        case .fruit:
            return UIColor.rgb(red: 34, green: 139, blue: 34)
        case .fish:
            return UIColor.rgb(red: 128, green: 0, blue: 0)
        case .meat:
            return UIColor.rgb(red: 139, green: 0, blue: 139)
        case .milk:
            return UIColor.rgb(red: 64, green: 64, blue: 64)
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
    
    // 육류
    case chicken
    case pork
    case duck
    case beef
    case lamb
    case sausage
    case bacon
    
    // 해물
    case fishes
    case squid
    case crab
    case lobster
    case shrimp
    case octopus
    
    // 유제품
    case milkDrink
    case cheese
    case butter
    case yogurt
    
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
            return "피망"
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
            
            // 과일
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
        case .chicken:
            return "닭고기"
        case .pork:
            return "돼지고기"
        case .duck:
            return "오리고기"
        case .beef:
            return "소고기"
        case .lamb:
            return "양고기"
        case .sausage:
            return "소시지"
        case .bacon:
            return "베이컨"
        case .fishes:
            return "생선"
        case .squid:
            return "오징어"
        case .crab:
            return "게"
        case .lobster:
            return "랍스터"
        case .shrimp:
            return "새우"
        case .octopus:
            return "문어"
        case .milkDrink:
            return "우유"
        case .cheese:
            return "치즈"
        case .butter:
            return "버터"
        case .yogurt:
            return "요거트"
        }
    }
    
    var expireFridgeDay: Int {
        switch self {
            // 채소
        case .Asparagus:
            return 2
        case .Eggplant:
            return 4
        case .Brocoli:
            return 7
        case .Cabbage:
            return 7
        case .Pumpkin:
            return 7
        case .Lettuce:
            return 5
        case .Corn:
            return 2
        case .Carrot:
            return 21
        case .Pepper:
            return 14
        case .Garlic:
            return 120
        case .Chili:
            return 14
        case .Cucumber:
            return 7
        case .Onion:
            return 28
        case .Potato:
            return 28
        case .Tomato:
            return 5
        case .Spinach:
            return 3
            // 과일
        case .Apple:
            return 30
        case .Orange:
            return 14
        case .Banana:
            return 5
        case .Melon:
            return 5
        case .Watermelon:
            return 7
        case .Strawberry:
            return 3
        case .Pineapple:
            return 5
        case .Avocado:
            return 5
        case .Kiwi:
            return 14
        case .Mango:
            return 7
        case .Grape:
            return 5
        case .chicken: return 2
        case .pork: return 5
        case .duck: return 3
        case .beef: return 5
        case .lamb: return 5
        case .sausage: return 14
        case .bacon: return 14
        case .fishes: return 2
        case .squid: return 2
        case .crab: return 2
        case .lobster: return 2
        case .shrimp: return 2
        case .octopus: return 2
        case .milkDrink: return 7
        case .cheese: return 28
        case .butter: return 90
        case .yogurt: return 14
        }
    }
    
    var expireFreezerDay: Int {
        switch self {
            // 채소
        case .Asparagus:
            return 365
        case .Eggplant:
            return 300
        case .Brocoli:
            return 365
        case .Cabbage:
            return 365
        case .Pumpkin:
            return 300
        case .Lettuce:
            return -1 // 냉동 보관 불가능
        case .Corn:
            return 365
        case .Carrot:
            return 365
        case .Pepper:
            return 365
        case .Garlic:
            return 365
        case .Chili:
            return 365
        case .Cucumber:
            return 300
        case .Onion:
            return 365
        case .Potato:
            return 365
        case .Tomato:
            return 365
        case .Spinach:
            return 365
            // 과일
        case .Apple:
            return 365
        case .Orange:
            return 365
        case .Banana:
            return -1 // 냉동 보관 불가능
        case .Melon:
            return 300
        case .Watermelon:
            return 300
        case .Strawberry:
            return -1 // 냉동 보관 불가능
        case .Pineapple:
            return 365
        case .Avocado:
            return 365
        case .Kiwi:
            return 8
        case .Mango:
            return 365
        case .Grape:
            return 365
            
        case .chicken: return 180
        case .pork: return 180
        case .duck: return 180
        case .beef: return 365
        case .lamb: return 180
        case .sausage: return 60
        case .bacon: return 60
        case .fishes: return 180
        case .squid: return 90
        case .crab: return 365
        case .lobster: return 365
        case .shrimp: return 365
        case .octopus: return 90
        case .milkDrink: return 180
        case .cheese: return 240
        case .butter: return 365
        case .yogurt: return 60
        }
    }
    
    var id: Int {
        switch self {
        case .Asparagus, .Eggplant, .Brocoli, .Cabbage, .Pumpkin, .Lettuce, .Corn, .Pepper, .Garlic, .Chili, .Cucumber, .Onion, .Tomato, .Spinach, .Carrot, .Potato:
            return 0
        case .Apple, .Orange, .Banana, .Melon, .Watermelon, .Strawberry, .Pineapple, .Avocado, .Kiwi, .Mango, .Grape:
            return 1
        case .chicken, .pork, .duck, .beef, .lamb, .sausage, .bacon:
            return 2
        case .fishes, .squid, .crab, .lobster, .shrimp, .octopus:
            return 3
        case .milkDrink, .cheese, .butter, .yogurt:
            return 4
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

struct ItemInfoModel: Codable {
    var itemName: String
    var expireFridgeDay: Int
    var expireFreeerDay: Int
}
