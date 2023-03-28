//
//  SelectedCellFooterView.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/22.
//

import UIKit
import SnapKit

class SelectedViewFooterView: UICollectionReusableView {
    //MARK: - Properties
    weak var delegate: InformationControllerDelegate?
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainAccent
        button.setTitle("AI에게 추천 요리 물어보기", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let warningAILabel: UILabel = {
        let label = UILabel()
        let text = "⏰AI의 답변에는 약 10초정도의 시간이 필요해요 \n💡AI의 답변은 부정확할 수 있으니 참고용으로만 활용해요 \n☝️AI 서비스는 서버 상황에 따라 불안정할 수 있어요."
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 20 // 들여쓰기 값 설정
        let attributedText = NSMutableAttributedString(string: text, attributes: [.paragraphStyle: paragraphStyle])
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = .lightGray
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
    
    //MARK: - Selector
    @objc private func actionButtonTapped() {
        delegate?.askToAIButtonTapped()
    }
    
    //MARK: - Functions
    private func setupUI() {
        addSubview(actionButton)
        actionButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
            actionButton.layer.cornerRadius = 20
            actionButton.clipsToBounds = true
        }
        
        addSubview(warningAILabel)
        warningAILabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(actionButton.snp.bottom).inset(-20)
        }
    }
}
