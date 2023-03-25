//
//  TopUserInfoView.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/20.
//

import SnapKit
import Kingfisher
import UIKit

protocol TouchUserInfoViewDelegate: AnyObject {
    func editUserInfoViewTapped()
}

class TopUserInfoView: UIView {
    //MARK: - Properties
    weak var delegate: TouchUserInfoViewDelegate?
    
    let userName: String
    let userEmail: String
    let userProfile: URL
    
    lazy var profileImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.kf.setImage(with: userProfile)
        return iv
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.text = userName
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.text = userEmail
        return label
    }()
    
    lazy var editImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "square.and.pencil")
        iv.contentMode = .scaleAspectFill
        iv.tintColor = .mainForeGround
        let tap = UITapGestureRecognizer(target: self, action: #selector(editImageTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    //MARK: - Lifecycle
    init(user: UserModel) {
        userName = user.userName
        userEmail = user.email
        userProfile = user.profileImage
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector
    @objc private func editImageTapped() {
        delegate?.editUserInfoViewTapped()
    }
    
    //MARK: - Functions
    private func setupUI() {
        backgroundColor = .systemGray6
        
        addSubview(profileImage)
        profileImage.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(60)
            profileImage.layer.cornerRadius = 30
            profileImage.clipsToBounds = true
        }
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        stack.axis = .vertical
        stack.spacing = 6
        
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.leading.equalTo(profileImage.snp.trailing).inset(-20)
            $0.centerY.equalToSuperview()
        }
        
        addSubview(editImageView)
        editImageView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(10)
            $0.width.height.equalTo(17)
        }
        
        layer.cornerRadius = 15
        clipsToBounds = true
    }
}
