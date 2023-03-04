//
//  FridgeController.swift
//  MyFridge
//
//  Created by 김지수 on 2023/02/28.
//

import UIKit
import Combine
import SnapKit

private let itemCellIdentifier = "FridgeItemCell"

protocol AuthDelegate: AnyObject {
    func logUserOut()
}

class FridgeController: UIViewController {
    
    //MARK: - Properties
    weak var authDelegate: AuthDelegate?
    private let viewModel: FridgeViewModel
    private var subscription = Set<AnyCancellable>()
    
    private let cellSpacing: Int = 10
    private let rowItemCount: Int = 2
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("추가하기", for: .normal)
        button.backgroundColor = .systemIndigo
        button.addTarget(self, action: #selector(handleAddButtonTapped), for: .touchUpInside)
        button.setTitleColor(.systemBackground, for: .normal)
        return button
    }()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        viewModel.fetchItems()
    }
    
    //MARK: - Bind
    private func bind() {
        viewModel.items
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }.store(in: &subscription)
    }
    
    //MARK: - Selector
    @objc func handleAddButtonTapped() {
//        임시 로그아웃기능
//        AuthService.shared.logUserOut { [weak self] in
//            self?.authDelegate?.logUserOut()
//        }
        let vc = CategoryRegisterController()
        let nav = MainNaviViewController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    //MARK: - Helper
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(5)
            $0.height.equalTo(40)
            addButton.layer.cornerRadius = 40 / 2
            addButton.clipsToBounds = true
        }
        
        viewModel.fetchItems()
    }
    
    func setupNav() {
        navigationItem.title = "우리집 냉장고"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupCollectionView() {
        collectionView.register(FridgeItemCell.self, forCellWithReuseIdentifier: itemCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

//MARK: - UICollectionView Delegate / DataSource
extension FridgeController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellIdentifier, for: indexPath) as? FridgeItemCell else { return UICollectionViewCell() }
        let item = viewModel.items.value[indexPath.row]
        let cellViewModel = FridgeItemViewModel(item: item, indexPath: indexPath)
        cell.cellViewModel = cellViewModel
        return cell
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
}
