//
//  Utilities.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/24.
//

import UIKit
import SnapKit

class AuthViewHelper {
    
    func inputContainerView(withImage image: UIImage, textField: UITextField) -> UIView {
        // 컨테이너
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // 아이콘
        let iv = UIImageView()
        iv.image = image
        
        view.addSubview(iv)
        iv.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(8)
            $0.width.height.equalTo(22)
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints {
            $0.leading.equalTo(iv.snp.trailing).inset(-8)
            $0.bottom.trailing.equalToSuperview().inset(8)
        }
        
        // 줄
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.snp.makeConstraints {
            $0.leading.equalTo(iv.snp.leading)
            $0.trailing.equalTo(textField.snp.trailing)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.75)
        }
        
        return view
    }
    
    // 로그인 / 회원가입 뷰의 텍스트필드
    func textFields(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        return tf
    }
    
    // 로그인 / 회원가입 뷰의 하단의 Sign Up, In 버튼
    func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
}
