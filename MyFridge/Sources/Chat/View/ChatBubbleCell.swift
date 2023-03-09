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
    
    let iconView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    lazy var iconContainerView: UIView = {

        let view = UIView()
        view.addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(7)
        }
        view.backgroundColor = .white
        return view
    }()

    var containerView = UIView()
    
    lazy var bubbleView: UIView = {
        let view = UIView()
        view.addSubview(contentLabel)
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        contentLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
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
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        setLayoutByChatType(viewModel: viewModel)
        iconView.image = UIImage(named: "SmartFridge")
        iconContainerView.backgroundColor = .white
        bubbleView.backgroundColor = viewModel.type.backgroundColor
        contentLabel.textColor = viewModel.type.textColor
        contentLabel.text = viewModel.content
        let flexibleWidth = viewModel.getCellSize().width
        bubbleView.widthAnchor.constraint(equalToConstant: flexibleWidth).isActive = true
    }
    
    private func setLayoutByChatType(viewModel: ChatBubbleCellViewModel) {
        switch viewModel.data.chatType {
            
        // 내 말풍선
        case .my:
            addSubview(bubbleView)
            bubbleView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.trailing.equalToSuperview().inset(10)
            }
        
        // AI의 말풍선
        case .ai, .processing:
            // 컨테이터
            containerView.addSubview(iconContainerView) // ai 아이콘
            iconContainerView.snp.makeConstraints {
                $0.top.leading.equalToSuperview()
                $0.width.height.equalTo(40)
                iconContainerView.layer.cornerRadius = 20
                iconContainerView.clipsToBounds = true
            }
            
            containerView.addSubview(bubbleView)
            bubbleView.snp.makeConstraints {
                $0.leading.equalTo(iconContainerView.snp.trailing).inset(-5)
                $0.top.bottom.trailing.equalToSuperview()
            }
            
            addSubview(containerView)
            containerView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalToSuperview().inset(10)
            }
        }
    }
}
