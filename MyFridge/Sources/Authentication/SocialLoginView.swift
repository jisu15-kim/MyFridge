//
//  SocialLoginView.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/18.
//

import UIKit
import SnapKit

class SocialLoginView: UIView {
    //MARK: - Properties
    let loginType: SocialLoginType
    let viewHeight: CGFloat
    
    lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = loginType.iconImage
        iv.contentMode = .scaleAspectFit
        iv.widthAnchor.constraint(equalToConstant: viewHeight - 30).isActive = true
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = loginType.title
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = loginType.textColor
        return label
    }()
    
    //MARK: - Lifecycle
    init(withSocialLoginType type: SocialLoginType, viewHeight: CGFloat) {
        self.loginType = type
        self.viewHeight = viewHeight
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    private func setupUI() {
        self.layer.cornerRadius = viewHeight / 2
        self.clipsToBounds = true
        self.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        self.backgroundColor = loginType.backgroundColor
        
        let stack = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        stack.spacing = 10
        
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(7)
            $0.centerX.equalToSuperview()
        }
    }
}
