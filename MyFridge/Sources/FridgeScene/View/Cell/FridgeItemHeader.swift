//
//  FridgeItemHeader.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/09.
//

import UIKit
import SnapKit

class FridgeItemHeader: UICollectionReusableView {
    //MARK: - Properties
    var keepType: KeepType? {
        didSet {
            configure()
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 23)
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
    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(3)
            $0.leading.equalToSuperview().inset(16)
        }
    }
    
    private func configure() {
        switch keepType {
        case .fridge:
            titleLabel.text = "💦냉장실"
        case .freezer:
            titleLabel.text = "❄️냉동실"
        default:
            return
        }
    }
}
