//
//  PreferenceCell.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/20.
//

import UIKit
import SnapKit

class MoreViewCell: UICollectionViewCell {
    //MARK: - Properties
    var type: MoreViewConfigureationType? {
        didSet {
            configure()
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    let nextImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = .mainForeGround
        return iv
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    private func setupUI() {
        addSubview(nextImageView)
        nextImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func configure() {
        guard let type = type else { return }
        titleLabel.text = type.rawValue
    }
}
