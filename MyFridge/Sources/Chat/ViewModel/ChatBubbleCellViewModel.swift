//
//  ChatBubbleCellViewModel.swift
//  MyFridge
//
//  Created by κΉμ§μ on 2023/03/07.
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
        self.processingDots = CurrentValueSubject("β ")
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
        let height = measurementLabelSize.height + CGFloat(20)
        return CGSize(width: width, height: height)
    }
}
