//
//  CategoryHeaderView.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/01.
//

import UIKit

class CategoryHeaderView: UICollectionReusableView {
        
    //MARK: - Properties
    var category: Category? {
        didSet {
            configure()
        }
    }
    
    private let guideLable: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    func setupUI() {
        addSubview(guideLable)
        guideLable.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configure() {
        if let category = category {
            guideLable.text = "\(category.categoryName)을 선택하셨군요!"
        } else {
            guideLable.text = "추가할 재료의 종류를 선택해주세요🤔"
            
        }
    }
}
