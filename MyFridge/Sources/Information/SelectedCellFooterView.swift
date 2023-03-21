//
//  SelectedCellFooterView.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/22.
//

import UIKit

class SelectedViewFooterView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
