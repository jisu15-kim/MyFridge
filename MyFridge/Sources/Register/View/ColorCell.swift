//
//  ColorCell.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/05.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    //MARK: - Properties
    var color: UserColorPreset? {
        didSet {
            configure()
        }
    }
    
    var selectRoundView: UIView = {
        let view = UIView()
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            configureSetColor(isSelected: isSelected)
        }
    }
    
    //MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        configureSetColor(isSelected: isSelected)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        layer.cornerRadius = 17.5
        clipsToBounds = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(selectRoundView)
        selectRoundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        selectRoundView.layer.cornerRadius = 17.5
        selectRoundView.clipsToBounds = true
        selectRoundView.layer.borderWidth = 4
    }
    
    private func configure() {
        guard let color = color else { return }
        backgroundColor = color.color
        selectRoundView.layer.borderColor = color.color.cgColor
    }
    
    private func configureSetColor(isSelected: Bool) {
        guard let color = color else { return }
        if isSelected == true {
            selectRoundView.layer.borderColor = UIColor.appMainTint.cgColor
        } else {
            selectRoundView.layer.borderColor = color.color.cgColor
        }
    }
}
