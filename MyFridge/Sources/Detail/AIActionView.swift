//
//  AIButtonView.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/04.
//

import UIKit
import SnapKit

class AIActionView: UIView {
    //MARK: - Properties
    let icon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    let actionTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Lifecycle
    init(image: UIImage, title: String) {
        super.init(frame: .zero)
        icon.image = image
        actionTitle.text = title
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    func setupUI() {
        addSubview(icon)
        icon.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(25)
            $0.width.equalTo(icon.snp.height)
        }
        
        addSubview(actionTitle)
        actionTitle.snp.makeConstraints {
            $0.leading.equalTo(icon.snp.trailing).inset(-10)
            $0.top.bottom.trailing.equalToSuperview().inset(10)
        }
        
        layer.cornerRadius = 15
        clipsToBounds = true
        
        backgroundColor = .systemGray6
    }
}
