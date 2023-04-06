//
//  UserConfirmController.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/19.
//

import UIKit
import SnapKit
import Combine

class UserConfirmController: UIViewController {
    //MARK: - Properties
    var user: UserModel
    var userUid: String
    
    weak var delegate: AuthDelegate?
    
    let allConfirmView = CustomAllConfirmView()
    
    lazy var termsView: CustomConfirmView = {
        let view = CustomConfirmView(title: "이용약관 동의", url: Link.terms, type: .essential)
        view.delegate = self
        return view
    }()
    
    lazy var overAgeView: CustomConfirmView = {
        let view = CustomConfirmView(title: "만 14세 이상 확인 동의", url: Link.terms, type: .essential)
        view.delegate = self
        return view
    }()
    
    lazy var privateInfoView: CustomConfirmView = {
        let view = CustomConfirmView(title: "개인정보 수집 및 이용 동의", url: Link.privacyPolicy, type: .essential)
        view.delegate = self
        return view
    }()
    
    lazy var marketingView: CustomConfirmView = {
        let view = CustomConfirmView(title: "마케팅 수신 정보 동의", url: Link.terms, type: .optional)
        view.delegate = self
        return view
    }()
    
    var subscriptions = Set<AnyCancellable>()
    
    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시작하기", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemGray3
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var safeAreaFillView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    
    //MARK: - Lifecycle
    init(user: UserModel, uid: String) {
        self.user = user
        self.userUid = uid
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    //MARK: - Selector
    @objc private func startButtonTapped() {
        if user.termsConfirmed == true {
            FirebaseLoginManager().userConfirmUpdate(uid: userUid, user: user) { [weak self] isSucessed in
                if isSucessed == true {
                    print("성공")
                    self?.delegate?.didFinishedUpdateUserConfirm()
                    self?.navigationController?.dismiss(animated: true)
                } else {
                    print("실패")
                }
            }
        }
    }
    
    //MARK: - Bind
    private func bind() {
        // 전체 동의 버튼
        allConfirmView.confirmed
            .sink {
                self.allConfirmAction(value: $0)
            }.store(in: &subscriptions)
        
        // 필수 동의 항목들
        termsView.confirmed
            .combineLatest(overAgeView.confirmed, privateInfoView.confirmed)
            .sink {
                self.essentialCheck(confirms: [$0, $1, $2])
            }.store(in: &subscriptions)
        
        // 마케팅 수신 동의
        marketingView.confirmed
            .sink { [weak self] value in
                self?.user.marketingConfirmed = value
            }.store(in: &subscriptions)
    }
    
    //MARK: - Functions
    private func allConfirmAction(value: Bool) {
        [termsView.confirmed, overAgeView.confirmed, privateInfoView.confirmed, marketingView.confirmed].forEach {
            $0.send(value)
        }
    }
    
    private func essentialCheck(confirms: [Bool]) {
        let check = confirms.allSatisfy { $0 }
        user.termsConfirmed = check
        if check == true {
            switchButtonColor(buttonColor: .mainAccent)
        } else {
            switchButtonColor(buttonColor: .systemGray3)
        }
    }
    
    private func switchButtonColor(buttonColor: UIColor) {
        startButton.backgroundColor = buttonColor
        safeAreaFillView.backgroundColor = buttonColor
        
    }
    
    private func setupUI() {
        navigationItem.title = "약관 동의"
        view.backgroundColor = .mainGrayBackground
        
        view.addSubview(allConfirmView)
        allConfirmView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        allConfirmView.setViewShadow(backView: view)
        
        let viewStack = UIStackView(arrangedSubviews: [termsView, overAgeView, privateInfoView, marketingView])
        viewStack.axis = .vertical
        viewStack.spacing = 10
        
        view.addSubview(viewStack)
        viewStack.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.top.equalTo(allConfirmView.snp.bottom).inset(-20)
        }
        
        view.addSubview(startButton)
        startButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        
        view.addSubview(safeAreaFillView)
        safeAreaFillView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

}

extension UserConfirmController: CustomConfirmViewDelegate {
    func viewLinkTapped(view: CustomConfirmView) {
        let url = view.itemUrl
        let vc = WebViewController(url: (url ?? URL(string: ""))!)
        present(vc, animated: true)
    }
}
