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
    }
}
