//
//  DetailRegisterController.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/01.
//

import UIKit
import Combine
import SnapKit
import SkyFloatingLabelTextField
import BetterSegmentedControl
import FloatingPanel

protocol RegistrationControllerDelegate: AnyObject {
    func actionDone(itemID: String)
}

private let reuseIdentifier = "ColorCell"

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
    
    private var subscription = Set<AnyCancellable>()
    private var selectedColor: CurrentValueSubject<UserColorPreset?, Never>
    
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
    
    private let colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return cv
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
        container.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        container.addSubview(iconContainerView)
        iconContainerView.snp.makeConstraints {
            $0.size.equalTo(70)
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            iconContainerView.layer.cornerRadius = 35
            iconContainerView.clipsToBounds = true
        }
        
        container.addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.leading.equalTo(iconContainerView.snp.trailing).inset(-10)
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
    
    //MARK: - Lifecycle
    
    init(withSelectedType type: ItemType, actionType: ActionType, itemViewModel: FridgeItemViewModel? = nil) {
        
        self.selectedItem = type
        self.actionType = actionType
        self.viewModel = itemViewModel
        self.selectedColor = CurrentValueSubject(nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.setupUI()
        self.setupNavi()
        self.configureUI()
        self.configureType()
        self.setupCollectionView()
        self.bind()
        self.configureSelectedColor()
    }
    
    //MARK: - Bind
    func bind() {
        selectedColor
            .receive(on: RunLoop.main)
            .sink { [weak self] color in
                guard let color = color else { return }
                guard let self = self else { return }
                self.iconContainerView.backgroundColor = color.color
                let indexPath = self.getColorToIndex(color: color)
                self.colorCollectionView.layoutIfNeeded()
                self.colorCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            }.store(in: &subscription)
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
        guard let selectedColor = selectedColor.value else { return }
        print("DEBUT - SelectedColor: \(selectedColor)")
        let itemConfig = FridgeItemConfig(itemName: name, expireDay: expireDay, memo: memo, color: selectedColor, keepType: keepType, itemType: selectedItem)
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
    
    @objc private func handleBackTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper
    private func setupNavi() {
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(handleDoneAction))
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        let leftBackButton = UIBarButtonItem(customView: backButton)
        
        navigationItem.rightBarButtonItem = rightItem
        navigationItem.leftBarButtonItem = leftBackButton
        
        switch actionType {
        case .register:
            navigationItem.title = "등록하기"
        case .modify:
            navigationItem.title = "수정하기"
        }
    }
    
    private func setupCollectionView() {
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        colorCollectionView.showsHorizontalScrollIndicator = false
        colorCollectionView.allowsSelection = true
    }
    
    private func configureSelectedColor() {
        
        switch actionType {
        case .register:
            // 시작할때 랜덤으로 하나 선택
            let randomValue = Int.random(in: 0..<UserColorPreset.allCases.count)
            let indexPath = IndexPath(item: randomValue, section: 0)
            selectedColor.send(UserColorPreset.allCases[randomValue])
        case .modify:
            // viewModel에서 불러오기
            guard let vm = viewModel else { return }
            let color = vm.item.color
            selectedColor.send(color) // 값 전달
        }
    }
    
    private func getColorToIndex(color: UserColorPreset) -> IndexPath {
        var selectedIndex = 0
        UserColorPreset.allCases.enumerated().forEach { (index, value) in
            if color == value {
                selectedIndex = index
            }
        }
        let indexPath = IndexPath(row: selectedIndex, section: 0)
        return indexPath
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
                                                   colorCollectionView,
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
    
    private func configureUI() {
        switch actionType {
        case .register:
            imageView.image = UIImage(named: selectedItem.rawValue)
            statusLabel.text = "#\(selectedItem.itemName) 등록하는 중"
            nameTextField.text = selectedItem.itemName
        case.modify:
            guard let viewModel = viewModel else { return }
            imageView.image = UIImage(named: selectedItem.rawValue)
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

extension DetailRegisterController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserColorPreset.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ColorCell else { return UICollectionViewCell() }
        cell.color = UserColorPreset.allCases[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell else { return }
        guard let color = cell.color else { return }
        selectedColor.send(color)
    }
}

extension DetailRegisterController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 35, height: 35)
    }
}
