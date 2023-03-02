//
//  FridgeItemCell.swift
//  MyFridge
//
//  Created by 김지수 on 2023/02/28.
//

import UIKit

class FridgeItemCell: UICollectionViewCell {
    
    //MARK: - Properties
    var itemName: String?
    
    var index: Int?
    
//    let categoryLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 13, weight: .light)
//        label.textAlignment = .left
//        label.textColor = .systemBackground
//        label.text = "야채"
//        label.sizeToFit()
//        label.backgroundColor = .lightGray
//        return label
//    }()
    
    let categoryLabel = CategoryView(text: "야채", backgroundColors: .systemIndigo)
    
    let itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.textColor = .systemBackground
        label.sizeToFit()
        return label
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemBackground
        iv.contentMode = .scaleAspectFit
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 3
        return iv
    }()
    
    private let expireLabel: UILabel = {
        let label = UILabel()
        label.text = "유통기한"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemBackground
        return label
    }()
    
    private let expireDateLabel: UILabel = {
        let label = UILabel()
        label.text = "D-12"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .systemBackground
        return label
    }()
    
    private let itemCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "벼룩시장에서 사온 양파"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemBackground
        label.numberOfLines = 2
        return label
    }()
    
    //MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = #colorLiteral(red: 0.2536777854, green: 0.7792022824, blue: 0.5558792949, alpha: 1)
        layer.cornerRadius = 25
        clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    private func setupUI() {
        
        addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        addSubview(itemTitleLabel)
        itemTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(categoryLabel.snp.leading)
            $0.top.equalTo(categoryLabel.snp.bottom).inset(-10)
        }
        
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(5)
            $0.size.equalTo(50)
            imageView.layer.cornerRadius = 25
            imageView.clipsToBounds = true
        }
        
        addSubview(expireLabel)
        expireLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.leading)
            $0.trailing.equalTo(imageView.snp.trailing)
            $0.top.equalTo(imageView.snp.bottom).inset(-14)
        }
        
        addSubview(expireDateLabel)
        expireDateLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.leading)
            $0.trailing.equalTo(imageView.snp.trailing)
            $0.top.equalTo(expireLabel.snp.bottom)
        }
        
        addSubview(itemCaptionLabel)
        itemCaptionLabel.snp.makeConstraints {
            $0.leading.equalTo(itemTitleLabel.snp.leading)
            $0.top.equalTo(itemTitleLabel.snp.bottom).inset(-10)
            $0.trailing.equalTo(expireLabel.snp.leading).inset(-2)
        }
    }
    
    func configure() {
        if let item = itemName {
            itemTitleLabel.text = item
        }
        
        if let index = index {
            let item = ItemType.allCases[index].rawValue
            imageView.image = UIImage(named: item)
        }
    }
}
