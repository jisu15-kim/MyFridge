//
//  ChatBubbleCell.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/07.
//

import UIKit
import SnapKit

class ChatBubbleCell: UICollectionViewCell {

    //MARK: - Properties
    var viewModel: ChatBubbleCellViewModel? {
        didSet {
            configure()
        }
    }
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemIndigo
        return view
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    func setupUI() {
        backgroundColor = .clear
        
        addSubview(bubbleView)
        bubbleView.layer.cornerRadius = 15
        bubbleView.clipsToBounds = true
        bubbleView.addSubview(contentLabel)
        bubbleView.snp.makeConstraints {
            $0.height.equalToSuperview()
        }
        contentLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        setLayoutByChatType(viewModel: viewModel)
        bubbleView.backgroundColor = viewModel.type.backgroundColor
        contentLabel.text = viewModel.content
        let flexibleWidth = viewModel.getCellSize(font: contentLabel.font).width
        bubbleView.widthAnchor.constraint(equalToConstant: flexibleWidth).isActive = true
    }
    
    private func setLayoutByChatType(viewModel: ChatBubbleCellViewModel) {
        switch viewModel.data.chatType {
        case .my:
            contentLabel.textAlignment = .right
            bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25).isActive = true
        case .ai:
            contentLabel.textAlignment = .left
            bubbleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        }
    }
}
