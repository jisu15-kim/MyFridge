//
//  CustomAllConfirmView.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/20.
//

import UIKit
import Combine

class CustomAllConfirmView: UIView {
    //MARK: - Properties
    var confirmed = CurrentValueSubject<Bool, Never>(false)
    var subscriptions = Set<AnyCancellable>()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "전체동의"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.text = "우리집 AI 냉장고 서비스 이용을 위한 약관입니다. 필수 항목 동의 후에 이용 가능합니다"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Selector
    @objc private func checkButtonTapped() {
        if confirmed.value == false {
            confirmed.send(true)
        } else {
            confirmed.send(false)
        }
    }
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Bind
    private func bind() {
        confirmed.receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.checkButtonConfigure(bool: value)
            }.store(in: &subscriptions)
    }
    
    //MARK: - Functions
    private func checkButtonConfigure(bool: Bool) {
        if bool == true {
            checkButton.tintColor = .mainAccent
        } else {
            checkButton.tintColor = .systemGray4
        }
    }
    
    private func setupUI() {
        backgroundColor = .systemGray6
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 6
        
        addSubview(checkButton)
        checkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(25)
        }
        
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(checkButton.snp.leading).inset(-20)
            $0.centerY.equalToSuperview()
        }
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
