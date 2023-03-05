//
//  DetailRegisterController.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/01.
//

import UIKit
import SnapKit
import SkyFloatingLabelTextField
import BetterSegmentedControl
import FloatingPanel

protocol RegistrationControllerDelegate: AnyObject {
    func actionDone(itemID: String)
}

// actionType에 따라서 Register / Modify 액션이 달라짐
class DetailRegisterController: UIViewController {
    
    enum ActionType {
        case register
        case modify
    }
    
    //MARK: - Properties
    weak var delegate: RegistrationControllerDelegate?
    private let selectedItem: ItemType
    private let actionType: ActionType
    private var viewModel: FridgeItemViewModel?
    
    private var keepType: KeepType = .fridge {
        didSet {
            configureType()
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var keepTypeSeg: BetterSegmentedControl = {
        let fridge = LabelSegment.segments(withTitles: ["냉장실", "냉동실"], normalTextColor: .systemGray, selectedTextColor: .black)
        let seg = BetterSegmentedControl(frame: .zero,
                                         segments: fridge,
                                         options: [.cornerRadius(15.0), .backgroundColor(UIColor.systemGray6), .indicatorViewBackgroundColor(.white)])
        seg.addTarget(self, action: #selector(keepTypeChanged(_:)), for: .valueChanged)
        return seg
    }()
    
    private lazy var aiActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemIndigo
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(handleAiAction), for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .black)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var headerContainerView: UIView = {
        let container = UIView()
        container.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        container.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.size.equalTo(50)
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        container.addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).inset(-10)
            $0.centerY.equalToSuperview()
        }
        
        return container
    }()
    
    private lazy var nameTitle = makeTitleLabel(withTitle: "재료 정보 입력하기")
    private lazy var keepRecomTitle = makeTitleLabel(withTitle: "추천 보관 방법")
    private lazy var nameTextField = makeTextField(placeholder: "품명", imageName: "pencil")
    private lazy var expireTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = makeTextField(placeholder: "유통기한", imageName: "calendar")
        tf.keyboardType = .numberPad
        tf.delegate = self
        return tf
    }()
    lazy var expireDateLabel = makeInfoLabel(text: "🗓️ 유통기한: - 까지")
    private lazy var memoTextField = makeTextField(placeholder: "수량, 원산지 등..", title: "메모", imageName: "doc.text")
    
    private var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private lazy var footerView: UIView = {
        let footer = UIView()
        
        return footer
    }()
    
    init(withSelectedType type: ItemType, actionType: ActionType, itemViewModel: FridgeItemViewModel? = nil) {
        
        self.selectedItem = type
        self.actionType = actionType
        self.viewModel = itemViewModel
        super.init(nibName: nil, bundle: nil)
        self.setupUI()
        self.setupNavi()
        self.configureUI(type: type)
        configureType()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selector
    @objc func handleAiAction() {
        showAIBottomSheet()
    }
    
    @objc func keepTypeChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            keepType = .fridge
        } else {
            keepType = .freezer
        }
    }
    
    @objc func handleDoneAction() {
        
        guard let name = nameTextField.text else { return }
        guard let expireDayString = expireTextField.text else { return }
        guard let expireDay = Int(expireDayString) else { return }
        guard let memo = memoTextField.text else { return }
        let color = "red"
        let itemConfig = FridgeItemConfig(itemName: name, expireDay: expireDay, memo: memo, color: color, keepType: keepType, itemType: selectedItem)
        let item = FridgeItemModel(config: itemConfig)
        
        switch actionType {
        case .register:
            Network().itemCreateUpdate(item: item, type: actionType) { [weak self] isSuccess in
                if isSuccess == true {
                    self?.navigationController?.dismiss(animated: true)
                }
            }
        case .modify:
            Network().itemCreateUpdate(item: item, type: actionType, itemID: viewModel?.itemID) { [weak self] isSuccess in
                if isSuccess == true {
                    guard let viewModel = self?.viewModel else { return }
                    self?.delegate?.actionDone(itemID: viewModel.itemID)
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    //MARK: - Helper
    private func setupNavi() {
        let item = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(handleDoneAction))
        navigationItem.rightBarButtonItem = item
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        let nameInfoLabel = makeInfoLabel(text: "💡품명은 자유롭게 수정 가능합니다")
        let expireInfoLabel = makeInfoLabel(text: "💡선택하신 재료의 추천 유통기한이 자동 입력됩니다")
        let memoInfoLabel = makeInfoLabel(text: "💡재료에 메모를 추가합니다(선택)")
        
        let nameStack = makeStackView(UIViews: [nameTextField, nameInfoLabel])
        let expireStack = makeStackView(UIViews: [expireTextField, expireInfoLabel, expireDateLabel])
        let memoStack = makeStackView(UIViews: [memoTextField, memoInfoLabel])
        
        let stack = UIStackView(arrangedSubviews: [headerContainerView,
                                                   keepTypeSeg,
                                                   nameStack,
                                                   expireStack,
                                                   memoStack,
                                                   aiActionButton])
        stack.spacing = 25
        stack.axis = .vertical
        
        [keepTypeSeg, nameStack, expireStack, memoStack, aiActionButton].forEach({
            $0.setViewShadow(backView: stack)
        })
        scrollView.addSubview(stack)
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        scrollView.layer.masksToBounds = false
    }
    
    private func configureUI(type: ItemType) {
        switch actionType {
        case .register:
            imageView.image = UIImage(named: type.rawValue)
            statusLabel.text = "#\(type.itemName) 등록하는 중"
            nameTextField.text = type.itemName
        case.modify:
            guard let viewModel = viewModel else { return }
            imageView.image = UIImage(named: type.rawValue)
            statusLabel.text = "#\(viewModel.itemName) 수정하는 중"
            nameTextField.text = viewModel.itemName
            expireTextField.text = "\(viewModel.item.expireDay)"
            memoTextField.text = viewModel.item.memo
            updateExpireDate(offsetDay: viewModel.item.expireDay)
        }
    }
    
    private func configureType() {
        aiActionButton.setTitle("AI에게 \(selectedItem.itemName) \(keepType.rawValue) 보관방법 물어보기", for: .normal)
    }
    
    private func makeTitleLabel(withTitle title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }
    
    private func makeTextField(placeholder: String, title: String? = nil, imageName: String) -> SkyFloatingLabelTextFieldWithIcon {
        let tf = SkyFloatingLabelTextFieldWithIcon(frame: .zero, iconType: .image)
        tf.placeholder = placeholder
        tf.iconImage = UIImage(systemName: imageName)
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.iconMarginLeft = 2
        tf.iconColor = .gray
        tf.selectedIconColor = .label
        tf.selectedTitleColor = .label
        tf.selectedLineColor = .label
        if let title = title {
            tf.title = title
        }
        return tf
    }
    
    private func makeInfoLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 10, weight: .light)
        return label
    }
    
    private func makeContentSpacingView(height: Int) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        return view
    }
    
    private func makeStackView(UIViews: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: UIViews)
        stack.spacing = 15
        stack.axis = .vertical
        stack.backgroundColor = .systemGray6
        stack.layer.cornerRadius = 15
        stack.clipsToBounds = true
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }
    
    private func showAIBottomSheet() {
        let panel = FloatingPanelController()
        let vm = AIChatViewModel(storageType: keepType, selectedItem: selectedItem, askType: .keep)
        let vc = AIChatViewController(viewModel: vm)
        panel.set(contentViewController: vc)
        panel.addPanel(toParent: self, animated: true)
        panel.backdropView.dismissalTapGestureRecognizer.isEnabled = true
    }
    
    private func calculateExpireDate(_ days: Int, to date: Date) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.day = days
        
        let calendar = Calendar.current
        return calendar.date(byAdding: dateComponents, to: date)
    }

    // 유통기한 업데이트 함수
    private func updateExpireDate(offsetDay: Int) {
        guard let futureDate = getDateFromDays(offsetDay) else { return }
        let dateString = dateConvertToString(futureDate)
        expireDateLabel.text = "🗓️ 유통기한: \(dateString) 까지"
    }
    
    // n일 후의 날짜 Date 구하기
    private func getDateFromDays(_ days: Int) -> Date? {
        switch actionType {
        case .register:
            let currentDate = Date()
            let futureDate = Calendar.current.date(byAdding: .day, value: days, to: currentDate)
            return futureDate
        case .modify:
            guard let viewModel = viewModel else { return Date() }
            let offsetDate = viewModel.item.timestamp
            let futureDate = Calendar.current.date(byAdding: .day, value: days, to: offsetDate)
            return futureDate
        }
        
    }
    
    // 구한 날짜 String으로
    private func dateConvertToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}

extension DetailRegisterController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let data = Int(text) ?? 0
        updateExpireDate(offsetDay: data)
    }
}
