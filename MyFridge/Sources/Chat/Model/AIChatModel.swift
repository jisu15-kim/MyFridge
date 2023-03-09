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
        case processing
        
        var backgroundColor: UIColor {
            switch self {
            case .my:
                return .mainAccent
            case .ai, .processing:
                return .mainReverseLabel
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .my:
                return .white
            case .ai, .processing:
                return .label
            }
        }
    }
    
    var content: String
    let chatType: ChatType
}
