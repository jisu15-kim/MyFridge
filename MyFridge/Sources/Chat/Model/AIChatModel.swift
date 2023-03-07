//
//  AIChatModel.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/07.
//

import UIKit

struct AIChatModel {
    enum ChatType: CaseIterable {
        case my
        case ai
        
        var backgroundColor: UIColor {
            switch self {
            case .my:
                return .yellow.withAlphaComponent(0.5)
            case .ai:
                return .white
            }
        }
    }
    
    let content: String
    let chatType: ChatType
}
