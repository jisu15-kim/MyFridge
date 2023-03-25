//
//  ChatHeader.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/07.
//

import UIKit
import SnapKit

protocol AIChatDelegate: AnyObject {
    func viewDismissTapped()
}

class ChatHeader: UICollectionReusableView {
    
    //MARK: - Properties
    var delegate: AIChatDelegate?
    
    lazy var imageContainerView: UIView = {
        let view = UIView()
        view.addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        view.backgroundColor = .white
        return view
    }()
    
    let iconView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "SmartFridge")
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.text = "냉장고와의 대화"
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "● 접속중"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .green
        return label
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleDismissTapped), for: .touchUpInside)
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
    @objc private func handleDismissTapped() {
        delegate?.viewDismissTapped()
    }
    
    //MARK: - Helper
    func setupUI() {
        backgroundColor = .mainAccent
        
        addSubview(imageContainerView)
        imageContainerView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.height.width.equalTo(60)
            $0.bottom.equalToSuperview().inset(10)
            imageContainerView.layer.cornerRadius = 30
            imageContainerView.clipsToBounds = true
        }
        
        let labelStack = UIStackView(arrangedSubviews: [nameLabel, statusLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 2
        addSubview(labelStack)
        labelStack.snp.makeConstraints {
            $0.leading.equalTo(imageContainerView.snp.trailing).inset(-20)
            $0.centerY.equalTo(imageContainerView)
        }
        
        addSubview(dismissButton)
        dismissButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
            $0.centerY.equalTo(imageContainerView)
        }
    }
}
