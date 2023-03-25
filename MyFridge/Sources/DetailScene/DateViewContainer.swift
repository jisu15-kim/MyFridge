//
//  DateViewContainer.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/04.
//

import UIKit
import SnapKit

class DateViewContainer: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    let date: Date
    
    init(title: String, date: Date, background: UIColor) {
        self.date = date
        super.init(frame: .zero)
        titleLabel.text = title
        setupUI()
        self.backgroundColor = background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = 3
        
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(15)
            
        }
        
        dateLabel.text = convertDate(from: self.date)
        
        layer.cornerRadius = 15
        clipsToBounds = true
    }
    
    private func convertDate(from: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: from)
    }
}
