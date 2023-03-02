//
//  FridgeController.swift
//  MyFridge
//
//  Created by 김지수 on 2023/02/28.
//

import UIKit
import SnapKit

private let itemCellIdentifier = "FridgeItemCell"

class FridgeController: UIViewController {
    
    //MARK: - Properties
    private let items = ["양파", "마늘", "당근", "파프리카", "다진마늘", "아스파라거스", "오이"]
    private let viewModel: FridgeViewModel
    
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
        setupCollectionView()
    }
    
    //MARK: - Selector
    @objc func handleAddButtonTapped() {
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
        print("Count: \(items.count)")
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellIdentifier, for: indexPath) as? FridgeItemCell else { return UICollectionViewCell() }
        cell.itemName = items[indexPath.row]
        cell.index = indexPath.row
        cell.configure()
        return cell
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
