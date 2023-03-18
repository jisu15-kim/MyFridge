//
//  ChatBubbleCellViewModel.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/07.
//

import UIKit
import Combine

class ChatBubbleCellViewModel {
    //MARK: - Properties
    let data: AIChatModel
    let type: AIChatModel.ChatType
    let content: String
    let maxViewWidth: CGFloat = CGFloat(240)
    
    var processingTimer: Timer?
    let processingDots: CurrentValueSubject<String, Never>
    
    //MARK: - Lifecycle
    init(data: AIChatModel) {
        self.data = data
        self.type = data.chatType
        self.content = data.content
        self.processingDots = CurrentValueSubject("● ")
    }
    
    //MARK: - Helper
    func getCellSize(text: String? = nil) -> CGSize {
        var offsetText = ""
        if let text = text {
            offsetText = text
        } else {
            offsetText = self.content
        }
        let measurementLabel = UILabel(frame: .zero)
        measurementLabel.text = offsetText
        measurementLabel.font = .systemFont(ofSize: 14)
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 240).isActive = true
        let measurementLabelSize = measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let width = measurementLabelSize.width + CGFloat(30)
        var height = measurementLabelSize.height + CGFloat(20)
        if type == .ai {
            height += 45
        }
        return CGSize(width: width, height: height)
    }
}
