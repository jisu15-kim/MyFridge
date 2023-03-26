//
//  FridgeController.swift
//  MyFridge
//
//  Created by 김지수 on 2023/02/28.
//

import UIKit
import Combine
import SnapKit
import Kingfisher

private let itemCellIdentifier = "FridgeItemCell"
private let headerIdentifier = "FridgeItemHeader"

protocol AuthDelegate: AnyObject {
    func logUserOut(user: UserModel)
    func didFinishedUpdateUserConfirm()
}

class FridgeController: UIViewController {
    
    //MARK: - Properties
    weak var authDelegate: AuthDelegate?
    private let viewModel: FridgeViewModel
    private var subscription = Set<AnyCancellable>()
    private var refreshControl = UIRefreshControl()
    
    private let cellSpacing: Int = 10
    private let rowItemCount: Int = 2
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 20, right: 10)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default)
        button.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .mainAccent
        button.addTarget(self, action: #selector(handleAddButtonTapped), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var userProfileView: UIImageView = {
        let iv = UIImageView()
        iv.image = defaultProfileImage
        iv.backgroundColor = .appMainBlack
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileViewTapped))
        iv.addGestureRecognizer(tap)
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let defaultProfileImage = UIImage(named: "defaultProfile")
    
    let emptyView = EmptyFridgeView()
    
    //MARK: - Lifecycle
    init() {
        viewModel = FridgeViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNav()
        bind()
        setupCollectionView()
        configureEmptyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        viewModel.fetchItems()
    }
    
    //MARK: - Bind
    private func bind() {
        viewModel.items
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
                self?.configureEmptyView()
            }.store(in: &subscription)
        viewModel.user
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                let url = user?.profileImage
                self?.userProfileView.kf.setImage(with: url, placeholder: self?.defaultProfileImage)
            }.store(in: &subscription)
    }
    
    //MARK: - Selector
    @objc func handleAddButtonTapped() {
        let vc = CategoryRegisterController()
        let nav = MainNaviViewController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    @objc func profileViewTapped() {
        //        임시 로그아웃기능
        UserDefaults.standard.setthisAccoutFirstLogin(value: false)
        NotificationManager().getAllNotifications()
        //        guard let user = viewModel.user.value else { return }
        //        authDelegate?.logUserOut(user: user)
    }
    
    @objc func handleRefreshControl() {
        self.viewModel.fetchItems()
            DispatchQueue.main.async { [weak self] in
                self?.refreshControl.endRefreshing()
            }
    }
    
    //MARK: - Helper
    func setupUI() {
        view.backgroundColor = .mainGrayBackground
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.width.height.equalTo(60)
            addButton.layer.cornerRadius = 30
            addButton.clipsToBounds = true
        }
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(400)
            emptyView.isHidden = true
        }
        
        viewModel.fetchItems()
    }
    
    func setupNav() {
        navigationItem.title = "우리집 냉장고"
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        let rightBtn = UIBarButtonItem(customView: userProfileView)
        userProfileView.snp.makeConstraints {
            $0.width.height.equalTo(40)
            userProfileView.layer.cornerRadius = 20
            userProfileView.clipsToBounds = true
        }
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .mainGrayBackground
        collectionView.register(FridgeItemCell.self, forCellWithReuseIdentifier: itemCellIdentifier)
        collectionView.register(FridgeItemHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configureEmptyView() {
        if viewModel.items.value.isEmpty {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
    }
}

//MARK: - UICollectionView Delegate / DataSource
extension FridgeController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return KeepType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let item = viewModel.items.value
        
        switch section {
        case 0:
            let fridgeItem = item.filter({ $0.item.keepType == .fridge })
            return fridgeItem.count
        case 1:
            let freezerItem = item.filter({ $0.item.keepType == .freezer })
            return freezerItem.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellIdentifier, for: indexPath) as? FridgeItemCell else { return UICollectionViewCell() }
        let item = viewModel.items.value
        
        switch indexPath.section {
        case 0:
            let viewModel = item.filter({ $0.item.keepType == .fridge })[indexPath.row]
            cell.cellViewModel = viewModel
            return cell
        case 1:
            let viewModel = item.filter({ $0.item.keepType == .freezer })[indexPath.row]
            cell.cellViewModel = viewModel
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as? FridgeItemHeader else { return UICollectionReusableView() }
        header.keepType = KeepType.allCases[indexPath.section]
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FridgeItemCell else { return }
        guard let viewModel = cell.cellViewModel else { return }
        let vc = DetailController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FridgeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frameWidth = view.frame.width
        let cellWidth = (frameWidth - CGFloat(cellSpacing * (rowItemCount + 1))) * 0.5
        
        return CGSize(width: cellWidth, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // 1. items 모델이 비어있으면 표시X
        if viewModel.items.value.isEmpty {
            return CGSize.zero
        } else {
            var isSectionExist: Bool = false
            viewModel.items.value.forEach {
                if KeepType.allCases[section] == $0.item.keepType {
                    isSectionExist = true
                }
            }
            if isSectionExist == true {
                // 2. 해당 Section에 아이템이 존재하면 표시O
                return CGSize(width: collectionView.frame.width, height: 45)
            } else {
                // 3. 해당 Section에 아이템이 존재하지 않다면 표시X
                return CGSize.zero
            }
        }
    }
}
