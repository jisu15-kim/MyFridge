//
//  LoginController.swift
//  TwitterTutorial
//
//  Created by 김지수 on 2023/02/24.
//

import UIKit
import SnapKit
import Firebase
import GoogleSignIn
import NaverThirdPartyLogin
import KakaoSDKUser
import KakaoSDKAuth

class LoginController: UIViewController {
    
    //MARK: - Properties
    let naverManager = NaverLoginManager()
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "backgroundImage")
        iv.alpha = 0.6
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "우리집 AI 냉장고"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 40, weight: .black)
        return label
    }()
    
    lazy var kakaoLoginButton = makeLoginButtons(type: .kakao)
    lazy var googleLoginButton = makeLoginButtons(type: .google)
    lazy var naverLoginButton = makeLoginButtons(type: .naver)
    lazy var appleLoginButton = makeLoginButtons(type: .apple)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        naverManager.delegate = self
    }
    
    //MARK: - Selectores
    @objc func handleKakaoLoginTapped() {
        print("로그인 시도합니다")
        KakaoLoginManager().tryKakaoLogin { user in
            FirebaseLoginManager().tryFirebaseAuth(withUser: user) { [weak self] isSuccess in
                if isSuccess == true {
                    self?.loginSuccessAndTransition()
                } else {
                    print("로그인 실패")
                }
            }
        }
    }
    
    @objc func handleGoogleLoginTapped() {
        GoogleLoginManager().tryGoogleLogin(viewController: self) { isSuccess in
            if isSuccess == true {
                self.loginSuccessAndTransition()
            }
        }
    }
    
    @objc func handleNaverLoginTapped() {
        print("네이버 로그인 시도")
        naverManager.tryNaverLogin { user in
            print(user)
        }
    }
    
    @objc func handleAppleLoginTapped() {
        AppleLoginManager(presenter: self).startSignInWithAppleFlow()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(200)
            $0.centerX.equalToSuperview()
        }
        
        navigationController?.navigationBar.barStyle = .black // Statusbar의 글씨 생상
        navigationController?.navigationBar.isHidden = true
        
        let stack = UIStackView(arrangedSubviews: [kakaoLoginButton,
                                                   naverLoginButton,
                                                   googleLoginButton,
                                                   appleLoginButton
                                                  ])
        stack.axis = .vertical
        stack.spacing = 15
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(250)
            $0.leading.trailing.equalToSuperview().inset(65)
        }
    }
    
    func loginSuccessAndTransition() {
        // 로그인 성공
        // UIApplication의 Window / 루트뷰를 찾아서, Auth 인증 함수 호출, 이후 Dismiss
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        guard let window = windowScenes?.windows.first(where: { $0.isKeyWindow }) else { return }
        
        guard let tab = window.rootViewController as? MainTabViewController else { return }
        tab.authenticateUserAndConfigureUI()
        
        self.dismiss(animated: true)
    }
    
    private func makeLoginButtons(type: SocialLoginType) -> SocialLoginView {
        let view = SocialLoginView(withSocialLoginType: type, viewHeight: 50)
        view.isUserInteractionEnabled = true
        switch type {
        case .kakao:
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleKakaoLoginTapped))
            view.addGestureRecognizer(tap)
        case .apple:
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleAppleLoginTapped))
            view.addGestureRecognizer(tap)
        case .google:
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleGoogleLoginTapped))
            view.addGestureRecognizer(tap)
        case .naver:
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleNaverLoginTapped))
            view.addGestureRecognizer(tap)
        }
        return view
    }
}

extension LoginController: NaverLoginManagerDelegate {
    func loginSuccessed() {
        loginSuccessAndTransition()
    }
}
