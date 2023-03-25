//
//  CustomTextField.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/07.
//

import UIKit

class CustomTextField: UIView {
    /**
     A function one passes in to do custom validation on the text field.
     
     - Parameter: textValue: The value of text to validate
     - Returns: A Bool indicating whether text is valid, and if not a String containing an error message
     */
    typealias CustomValidation = ((_ textValue: String?) -> (Bool, String)?)
    
    let iconImageView: UIImageView
    let textField = UITextField()
    let dividerView = UIView()
    let errorLabel = UILabel()
    
    let placeHolderText: String
    var customValidation: CustomValidation?
    
    var text: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    init(placeHolderText: String, imageName: String) {
        self.placeHolderText = placeHolderText
        self.iconImageView = UIImageView(image: UIImage(systemName: imageName))
        super.init(frame: .zero)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 60)
    }
}

extension CustomTextField {
    
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.tintColor = .label
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeHolderText
        textField.attributedPlaceholder = NSAttributedString(string:placeHolderText,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])

        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = .separator
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = .systemRed
        errorLabel.font = .preferredFont(forTextStyle: .footnote)
        errorLabel.text = "Your password must meet the requirements below"
        errorLabel.numberOfLines = 0
        errorLabel.lineBreakMode = .byWordWrapping

        errorLabel.isHidden = true
    }
    
    func layout() {
        addSubview(iconImageView)
        addSubview(textField)
        addSubview(dividerView)
        addSubview(errorLabel)
        
        // lock
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        // textfield
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalToSystemSpacingAfter: iconImageView.trailingAnchor, multiplier: 1),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // divider
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4)
        ])
        
        // error
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 7),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        // CHCR
        iconImageView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        textField.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
    }
}
