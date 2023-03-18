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
    
    lazy var bubbleView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [contentLabel])
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
//        contentLabel.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview().inset(15)
//            $0.centerY.equalToSuperview()
//        }
        view.axis = .vertical
        view.spacing = 10
        view.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var copyButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainAccent
        button.setAttributedTitle(NSAttributedString(string: "답변 복사하기", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]), for: .normal)
        button.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector
    @objc func copyButtonTapped() {
        guard let vm = viewModel else { return }
        UIPasteboard.general.string = vm.content
        copyButton.backgroundColor = .systemGray6
        copyButton.setAttributedTitle(NSAttributedString(string: "복사 완료", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]), for: .normal)
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
        case .ai, .processing, .greeting:
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
            
            // AI 답변이라면? - 복사 버튼 추가
            if viewModel.data.chatType == .ai {
                bubbleView.addArrangedSubview(copyButton)
                copyButton.snp.makeConstraints {
                    $0.height.equalTo(35)
                    copyButton.layer.cornerRadius = 35 / 2
                    copyButton.clipsToBounds = true
                }
            }
            
            addSubview(containerView)
            containerView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalToSuperview().inset(10)
            }
        }
    }
}
