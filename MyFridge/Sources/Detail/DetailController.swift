//
//  DetailController.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/04.
//

import UIKit
import SnapKit

class DetailController: UIViewController {
    //MARK: - Properties
    var viewModel: FridgeItemViewModel {
        didSet {
            configure()
        }
    }
    
    lazy var categoryLabel = CategoryView(text: viewModel.category, backgroundColors: .systemIndigo)
    lazy var keepTypeLabel = CategoryView(text: viewModel.item.keepType.rawValue, backgroundColors: .lightGray)
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var iconContainerView: UIView = {
        let view = UIView()
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        return view
    }()
    
    let itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .left
        label.textColor = .label
        label.sizeToFit()
        return label
    }()
    
    let expireInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.backgroundColor = .mainReverseLabel
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        return label
    }()
    
    lazy var registDateContainer = DateViewContainer(title: "등록일자", date: viewModel.registedDate, background: .mainReverseLabel)
    lazy var expireContainer = DateViewContainer(title: "유통기한", date: viewModel.expireDate, background: .mainReverseLabel)
    
    let memoTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .left
        label.text = "메모"
        return label
    }()
    
    let memoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    lazy var memoContainer: UIView = {
        let view = UIView()
        view.addSubview(memoLabel)
        memoLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleMenuTapped))
        view.addGestureRecognizer(tap)
        view.backgroundColor = .systemYellow.withAlphaComponent(0.2)
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    let AIActionTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .left
        label.text = "AI에게 물어보기"
        return label
    }()
    
    lazy var aiActionView1: AIActionView = {
        let view = AIActionView(image: #imageLiteral(resourceName: "storage"), title: "\(viewModel.item.itemType.itemName) 보관방법 알려줘")
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleAIViewTapped1))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        view.backgroundColor = .mainReverseLabel
        return view
    }()
    
    lazy var aiActionView2: AIActionView = {
        let view = AIActionView(image: #imageLiteral(resourceName: "receipe"), title: "\(viewModel.item.itemType.itemName) 추천 레시피 알려줘")
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleAIViewTapped2))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        view.backgroundColor = .mainReverseLabel
        return view
    }()
    
    //MARK: - Lifecycle
    init(viewModel: FridgeItemViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavi()
        setupUI()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    //MARK: - Selector
    @objc func handleMenuTapped() {
        let actionSheet = UIAlertController()
        print(viewModel.itemID)
        
        let modify = UIAlertAction(title: "수정하기", style: .default) { [weak self] _ in
            guard let type = self?.viewModel.item.itemType else { return }
            let vc = DetailRegisterController(withSelectedType: type, actionType: .modify, itemViewModel: self?.viewModel)
            vc.delegate = self
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        let delete = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteItem { isSucess in
                if isSucess == true {
                    var uids: [String] = []
                    self?.viewModel.item.userNotiData.forEach({
                        uids.append($0.uid)
                    })
                    NotificationManager().deleteItemNotifications(uids: uids)
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    print("ERROR: 삭제 실패 alert")
                }
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(modify)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    @objc func handleBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // 보관 방법
    @objc func handleAIViewTapped1() {
        let keepType = viewModel.item.keepType
        let selected = viewModel.item.itemType
        let viewModel = AIChatViewModel(storageType: keepType, selectedItem: selected, askType: .keep)
        let vc = AIChatViewController(viewModel: viewModel)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    // 레시피
    @objc func handleAIViewTapped2() {
        let keepType = viewModel.item.keepType
        let selected = viewModel.item.itemType
        let viewModel = AIChatViewModel(storageType: keepType, selectedItem: selected, askType: .recipe)
        let vc = AIChatViewController(viewModel: viewModel)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    //MARK: - Helper
    private func setupNavi() {
        navigationItem.title = "상세보기"
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        let leftBackButton = UIBarButtonItem(customView: backButton)
        
        let menuButton = UIButton(type: .system)
        menuButton.setImage(UIImage(named: "menu"), for: .normal)
        menuButton.addTarget(self, action: #selector(handleMenuTapped), for: .touchUpInside)
        let rightMenuButton = UIBarButtonItem(customView: menuButton)
        
        navigationItem.leftBarButtonItem = leftBackButton
        navigationItem.rightBarButtonItem = rightMenuButton
    }
    
    private func setupUI() {
        view.backgroundColor = .mainGrayBackground
        
        view.addSubview(iconContainerView)
        iconContainerView.snp.makeConstraints {
            $0.leading.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.width.height.equalTo(90)
            iconContainerView.backgroundColor = .lightGray
            iconContainerView.layer.cornerRadius = 45
            iconContainerView.clipsToBounds = true
        }
        
        let capsuleStack = UIStackView(arrangedSubviews: [categoryLabel, keepTypeLabel, UIView()])
        capsuleStack.spacing = 5
        let stack = UIStackView(arrangedSubviews: [capsuleStack, itemTitleLabel])
        stack.axis = .vertical
        stack.spacing = 7
        
        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.leading.equalTo(iconContainerView.snp.trailing).inset(-16)
            $0.centerY.equalTo(iconContainerView)
        }
        
        let lineView = UIView()
        view.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
            $0.top.equalTo(iconContainerView.snp.bottom).inset(-20)
            lineView.backgroundColor = .lightGray
        }
        
        view.addSubview(expireInfoLabel)
        expireInfoLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(lineView.snp.bottom).inset(-15)
            $0.height.equalTo(40)
        }
        
        let dateStack = UIStackView(arrangedSubviews: [registDateContainer, expireContainer])
        view.addSubview(dateStack)
        dateStack.spacing = 15
        dateStack.distribution = .fillEqually
        
        dateStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.top.equalTo(expireInfoLabel.snp.bottom).inset(-15)
        }
        
        view.addSubview(memoTitle)
        memoTitle.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(dateStack.snp.bottom).inset(-30)
            $0.height.equalTo(20)
        }
        
        view.addSubview(memoContainer)
        memoContainer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(memoTitle.snp.bottom).inset(-10)
            $0.height.equalTo(60)
        }
        
        view.addSubview(AIActionTitle)
        AIActionTitle.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(memoContainer.snp.bottom).inset(-30)
            $0.height.equalTo(20)
        }
        
        let aiStack = UIStackView(arrangedSubviews: [aiActionView1, aiActionView2])
        aiStack.axis = .horizontal
        aiStack.spacing = 15
        aiStack.distribution = .fillEqually
        
        view.addSubview(aiStack)
        aiStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(AIActionTitle.snp.bottom).inset(-10)
            $0.height.equalTo(100)
        }
    }
    
    private func configure() {
        imageView.image = viewModel.itemIcon
        itemTitleLabel.text = viewModel.itemName
        expireInfoLabel.attributedText = viewModel.expireInfoText
        memoLabel.attributedText = viewModel.memoText
        iconContainerView.backgroundColor = viewModel.item.color.color
        categoryLabel.backgroundColor = viewModel.item.category.backgroundColor
    }
    
}

extension DetailController: RegistrationControllerDelegate {
    func actionDone(itemID: String) {
        Network().fetchSingleItem(itemID: itemID) { [weak self] item in
            let viewModel = FridgeItemViewModel(item: item)
            self?.viewModel = viewModel
        }
    }
}
