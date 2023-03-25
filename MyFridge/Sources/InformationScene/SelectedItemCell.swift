//
//  SelectedItemCell.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/22.
//

import UIKit
import SnapKit

class SelectedItemCell: UICollectionViewCell {
    //MARK: -  Properties
    var itemViewModel: FridgeItemViewModel? {
        didSet {
            configure()
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var iconContainerView: UIView = {
        let view = UIView()
        view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(3)
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    private func setupUI() {
        addSubview(iconContainerView)
        iconContainerView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(5)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconContainerView.snp.trailing).inset(-5)
            $0.centerY.equalToSuperview()
        }
        
        layer.cornerRadius = 25
        clipsToBounds = true
    }
    
    private func configure() {
        guard let vm = itemViewModel else { return }
        iconImageView.image = vm.itemIcon
        titleLabel.text = vm.itemName
        backgroundColor = vm.item.color.color
    }
}
