//
//  FridgeItemCell.swift
//  MyFridge
//
//  Created by 김지수 on 2023/02/28.
//

import UIKit
import SnapKit

class FridgeItemCell: UICollectionViewCell {
    
    //MARK: - Properties
    var cellViewModel: FridgeItemViewModel? {
        didSet {
            configure()
        }
    }
    
    let categoryLabel = CategoryView(text: "야채", backgroundColors: .systemIndigo)
    
    let itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.textColor = .mainForeGround
        label.sizeToFit()
        return label
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var iconContainerView: UIView = {
        let view = UIView()
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        view.layer.borderColor = UIColor.mainAccent.cgColor
        view.layer.borderWidth = 3
        return view
    }()
    
    private let expireLabel: UILabel = {
        let label = UILabel()
        label.text = "유통기한"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        label.textColor = .label
        return label
    }()
    
    private let expireDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let memoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    //MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
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
        
        addSubview(iconContainerView)
        iconContainerView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(10)
            $0.size.equalTo(60)
            iconContainerView.layer.cornerRadius = 30
            iconContainerView.clipsToBounds = true
        }
        
        addSubview(expireLabel)
        expireLabel.snp.makeConstraints {
            $0.leading.equalTo(iconContainerView.snp.leading)
            $0.trailing.equalTo(iconContainerView.snp.trailing)
            $0.top.equalTo(iconContainerView.snp.bottom).inset(-8)
        }
        
        addSubview(expireDateLabel)
        expireDateLabel.snp.makeConstraints {
            $0.leading.equalTo(iconContainerView.snp.leading)
            $0.trailing.equalTo(iconContainerView.snp.trailing)
            $0.top.equalTo(expireLabel.snp.bottom)
        }
        
        addSubview(memoLabel)
        memoLabel.snp.makeConstraints {
            $0.leading.equalTo(itemTitleLabel.snp.leading)
            $0.top.equalTo(itemTitleLabel.snp.bottom).inset(-10)
            $0.trailing.equalTo(expireLabel.snp.leading).inset(-2)
        }
        
        self.setViewShadow(backView: self)
    }
    
    func configure() {
        guard let viewModel = cellViewModel else { return }
        itemTitleLabel.text = viewModel.itemName
        imageView.image = viewModel.itemIcon
        expireDateLabel.text = viewModel.expireDDay
        categoryLabel.text = viewModel.category
        memoLabel.text = viewModel.memoShortText
        backgroundColor = .mainReverseLabel
        iconContainerView.backgroundColor = viewModel.item.color.color
    }
}
