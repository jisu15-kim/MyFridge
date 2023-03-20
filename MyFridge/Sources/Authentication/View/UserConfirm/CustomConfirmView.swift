//
//  CustomConfirmView.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/19.
//

import UIKit
import Combine
import SnapKit

protocol CustomConfirmViewDelegate: AnyObject {
    func viewLinkTapped(view: CustomConfirmView)
}

class CustomConfirmView: UIView {
    enum ConfirmType: String {
        case essential = "(필수)"
        case optional = "(선택)"
    }
    
    //MARK: - Properties
    var confirmed = CurrentValueSubject<Bool, Never>(false)
    var subscriptions = Set<AnyCancellable>()
    
    let itemTitle: String
    let itemUrl: String
    let itemType: ConfirmType
    
    weak var delegate: CustomConfirmViewDelegate?
    
    // 타이틀
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = itemTitle + " " + itemType.rawValue
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = .systemGray
        let linkLabelText = "이용약관 보기"
        let linkLabelAttributedString = NSMutableAttributedString(string: "이용약관 보기")
        linkLabelAttributedString.addAttribute(.underlineStyle , value: 1, range: NSRange.init(location: 0, length: linkLabelText.count))
        label.attributedText = linkLabelAttributedString
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewUrlTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()
    
    lazy var checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    init(title: String, url: String, type: ConfirmType) {
        itemTitle = title
        itemUrl = url
        itemType = type
        super.init(frame: .zero)
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
    
    //MARK: - Selector
    @objc private func viewUrlTapped() {
        delegate?.viewLinkTapped(view: self)
    }
    
    @objc private func checkButtonTapped() {
        if confirmed.value == false {
            confirmed.send(true)
        } else {
            confirmed.send(false)
        }
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
        let stack = UIStackView(arrangedSubviews: [titleLabel, urlLabel])
        stack.axis = .vertical
        stack.spacing = 3
        
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        addSubview(checkButton)
        checkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(25)
        }
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
