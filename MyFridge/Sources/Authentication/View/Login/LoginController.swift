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
    
    var currentNonce: String?
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "backgroundImage")
        iv.alpha = 0.6
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logo")
        return iv
    }()
    
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let onboardingLabel: UILabel = {
        let label = UILabel()
        label.text = "즐거운 요리를 위한 나만의 AI 비서"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "우리집 AI 냉장고"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let copyrightLabel: UILabel = {
        let label = UILabel()
        label.text = "copyright by JSCT 2023.\nAll right reserved."
        label.textAlignment = .center
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 10, weight: .light)
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
        naverManager.tryNaverLogin { [weak self] user in
            self?.loginSuccessAndTransition()
        }
    }
    
    @objc func handleAppleLoginTapped() {
        startSignInWithAppleFlow()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        let topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .mainAccent
        
        view.addSubview(topBackgroundView)
        topBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        topBackgroundView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        topBackgroundView.setViewShadow(backView: self.view)
        
        let greetingStack = UIStackView(arrangedSubviews: [titleLabel, onboardingLabel])
        greetingStack.axis = .vertical
        greetingStack.spacing = 5
        
        topBackgroundView.addSubview(greetingStack)
        greetingStack.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom)
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
        
        view.addSubview(copyrightLabel)
        copyrightLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(30)
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
        view.setViewShadow(backView: self.view)
        return view
    }
}

extension LoginController: NaverLoginManagerDelegate {
    func loginSuccessed() {
        loginSuccessAndTransition()
    }
}
