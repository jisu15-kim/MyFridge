//
//  File.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/20.
//

import UIKit
import SnapKit

class SettingController: UIViewController {
    //MARK: - Properties
    
    let switchControl = UISwitch()
    let rootVC = AppHelper.getRootController()
    
    lazy var marketingToggleView: UIView = {
        let view = UIView()
        let title = UILabel()
        title.text = "마케팅 수신 동의"
        title.font = .systemFont(ofSize: 16)
        view.addSubview(title)
        title.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }
        
        view.addSubview(switchControl)
        switchControl.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        return view
    }()
    
    lazy var logoutView: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그아웃", for: .normal)
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var deleteAccountView: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원 탈퇴", for: .normal)
        button.addTarget(self, action: #selector(deleteAccoutTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        configureSwitch()
    }
    
    //MARK: - Bind
    private func bind() {
        // SwitchControl Listener 생성
        switchControl.setOnValueChangeListener {
            guard let tab = AppHelper.getRootController(),
                  let uid = tab.uid,
                  var user = tab.user else { return }
            user.marketingConfirmed = $0
            Network().changeMarktetingConfirms(uid: uid, user: user) { isSucessed in
                // DB 요청 성공하면 탭바에서 user 다시 받아오기
                if isSucessed == true {
                    tab.fetchUser()
                }
            }
        }
    }
    //MARK: - Selector
    @objc private func logoutTapped() {
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "로그아웃", style: .destructive) { [weak self] _ in
            self?.logout()
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
    @objc private func deleteAccoutTapped() {
        let alert = UIAlertController(title: "회원탈퇴", message: "회원탈퇴 하시겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "탈퇴", style: .destructive) { [weak self] _ in
            self?.reAskDeleteAccount()
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    //MARK: - Functions
    private func reAskDeleteAccount() {
        let alert = UIAlertController(title: "회원탈퇴", message: "저장된 정보가 모두 지워집니다. 그래도 탈퇴하시겠어요?😢", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "탈퇴", style: .destructive) { [weak self] _ in
            guard let root = self?.rootVC else { return }
            
            AuthService.shared.deleteAccout { [weak self] isSucessed in
                if isSucessed == true {
                    self?.navigationController?.dismiss(animated: true)
                    root.authenticateUserAndConfigureUI()
                }
            }
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    private func logout() {
        guard let root = rootVC else { return }
        root.logout()
    }
    
    private func setupUI() {
        view.backgroundColor = .mainGrayBackground
        
        view.addSubview(marketingToggleView)
        marketingToggleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(60)
        }
        
        view.addSubview(logoutView)
        logoutView.snp.makeConstraints {
            $0.top.equalTo(marketingToggleView.snp.bottom).inset(-25)
            $0.leading.equalToSuperview().inset(16)
        }
        
        view.addSubview(deleteAccountView)
        deleteAccountView.snp.makeConstraints {
            $0.top.equalTo(logoutView.snp.bottom).inset(-10)
            $0.leading.equalToSuperview().inset(16)
        }
    }
    
    private func configureSwitch() {
        guard let tab = AppHelper.getRootController(),
              let user = tab.user,
              let marketingConfirmed = user.marketingConfirmed else { return }
        
        switchControl.isOn = marketingConfirmed
    }
}

extension UISwitch {
    func setOnValueChangeListener(onValueChanged :@escaping (Bool) -> Void){
        self.addAction(UIAction(){ action in
            onValueChanged(self.isOn)
        }, for: .valueChanged)
    }
}
