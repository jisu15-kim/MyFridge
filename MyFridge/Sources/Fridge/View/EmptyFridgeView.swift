//
//  EmptyFridgeView.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/18.
//

import UIKit
import SnapKit

class EmptyFridgeView: UIView {
    //MARK: - Properties
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "emptyFridge")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "냉장고가 비어있어요😢 \n 아래 버튼을 눌러 품목을 추가해보세요"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 18)
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
    
    //MARK: - Functions
    private func setupUI() {
        
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(200)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).inset(-70)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
