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
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        //        iv.image = #imageLiteral(resourceName: "Watermelon")
        return iv
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "Watermelon")
        let view = AuthViewHelper().inputContainerView(withImage: image, textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "Watermelon")
        let view = AuthViewHelper().inputContainerView(withImage: image, textField: passwordTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = AuthViewHelper().textFields(withPlaceholder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = AuthViewHelper().textFields(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var kakaoLoginButton: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "kakao_login")
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleKakaoLoginTapped))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    lazy var googleLoginButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.addTarget(self, action: #selector(handleGoogleLoginTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var naverLoginButton: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "naver_login")
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleNaverLoginTapped))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.systemIndigo, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.addTarget(nil, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = AuthViewHelper().attributedButton("Don't have an account? ", "Sign Up")
        button.addTarget(nil, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
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
        naverManager.tryLogout()
//        GoogleLoginManager().tryGoogleLogin(viewController: self) { isSuccess in
//            if isSuccess == true {
//                self.loginSuccessAndTransition()
//            }
//        }
    }
    
    @objc func handleNaverLoginTapped() {
        print("네이버 로그인 시도")
        naverManager.tryNaverLogin { user in
            print(user)
        }
    }
    
    @objc func handleLogin() {
        //        guard let email = emailTextField.text else { return }
        //        guard let password = passwordTextField.text else { return }
        //
        //        tryFirebaseLogin(withEmail: email, password: password)
    }
    
    @objc func handleShowSignUp() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        navigationController?.navigationBar.barStyle = .black // Statusbar의 글씨 생상
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.centerX.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.height.equalTo(150)
        }
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   kakaoLoginButton,
                                                   naverLoginButton,
                                                   googleLoginButton,
                                                   loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.bottom.equalTo(dontHaveAccountButton.snp.top).inset(-100)
            $0.leading.trailing.equalToSuperview().inset(28)
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
}

extension LoginController: NaverLoginManagerDelegate {
    func loginSuccessed() {
        loginSuccessAndTransition()
    }
}
