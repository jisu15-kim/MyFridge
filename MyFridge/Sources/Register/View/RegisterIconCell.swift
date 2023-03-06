//
//  RegisterIconCell.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/01.
//

import UIKit

class RegisterIconCell: UICollectionViewCell {
    
    //MARK: - Properties
    var category: Category? {
        didSet {
            setupCategoryUI()
            configure()
        }
    }
    
    var itemType: ItemType? {
        didSet {
            setupItemUI()
            configure()
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCategoryUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    func setupCategoryUI() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        addSubview(itemTitleLabel)
        itemTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).inset(-10)
        }
    }
    
    func setupItemUI() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        addSubview(itemTitleLabel)
        itemTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).inset(-10)
        }
    }
    
    func configure() {
        if let category = category {
            configureDetail(image: category.rawValue, text: category.categoryName)
        }
        
        if let item = itemType {
            configureDetail(image: item.rawValue, text: item.itemName)
        }
    }
    
    private func configureDetail(image: String, text: String) {
        imageView.image = UIImage(named: image)
        itemTitleLabel.text = text
    }
}
