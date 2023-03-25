//
//  CategoryCapsuleView.swift
//  MyFridge
//
//  Created by 김지수 on 2023/02/28.
//

import UIKit

class CategoryView: UIView {

    private let padding: CGFloat = 8.0
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    var text: String? {
        didSet {
            label.text = text
            updateLabelSize()
        }
    }
    
    var backgroundColors: UIColor = .darkGray {
        didSet {
            self.backgroundColor = backgroundColors
        }
    }
    
    convenience init(text: String, backgroundColors: UIColor) {
        self.init(frame: .zero)
        self.text = text
        self.backgroundColors = backgroundColors
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        self.backgroundColor = backgroundColors
    }
    
    private func setupViews() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label.text = text
        self.backgroundColor = backgroundColors
    }
    
    private func updateLabelSize() {
        guard let text = text else { return }
        let labelSize = text.size(withAttributes: [.font: label.font!])
        let width = labelSize.width + padding * 2
        frame.size.width = width
        label.frame = CGRect(x: padding, y: 0, width: labelSize.width, height: frame.height)
        label.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override var intrinsicContentSize: CGSize {
        guard let text = text else { return .zero }
        let labelSize = text.size(withAttributes: [.font: label.font as Any])
        self.layer.cornerRadius = labelSize.height / 2
        self.clipsToBounds = true
        return CGSize(width: labelSize.width + padding * 2, height: labelSize.height)
    }

    override func sizeToFit() {
        frame.size = intrinsicContentSize
    }
}
