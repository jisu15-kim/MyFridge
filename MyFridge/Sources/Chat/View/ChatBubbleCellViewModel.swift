//
//  ChatBubbleCellViewModel.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/07.
//

import UIKit

class ChatBubbleCellViewModel {
    //MARK: - Properties
    let data: AIChatModel
    let type: AIChatModel.ChatType
    let content: String
    let maxViewWidth: CGFloat = CGFloat(240)
    
    //MARK: - Lifecycle
    init(data: AIChatModel) {
        self.data = data
        self.type = data.chatType
        self.content = data.content
    }
    
    //MARK: - Helper
    func getCellSize(font: UIFont) -> CGSize {
        let measurementLabel = UILabel(frame: .zero)
        measurementLabel.text = content
        measurementLabel.font = font
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(lessThanOrEqualToConstant: maxViewWidth).isActive = true
        let measurementLabelSize = measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let width = measurementLabelSize.width + CGFloat(30)
        let height = measurementLabelSize.height + CGFloat(20)
        return CGSize(width: width, height: height)
    }
}
