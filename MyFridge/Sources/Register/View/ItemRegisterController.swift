//
//  ItemRegisterController.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/01.
//

import UIKit

class ItemRegisterController: UIViewController {
    
    private let reuseIdentifier = "RegisterIconCell"
    private let headerIdentifier = "CategoryHeaderView"
    
    //MARK: - Properties
    let selectedCategory: Category
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 35
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 5, left: 25, bottom: 5, right: 25)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    //MARK: - Lifecycle
    init(category: Category) {
        self.selectedCategory = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavi()
        setupUI()
        setupCollectionView()
    }
    //MARK: - Selector
    @objc func handleDismissTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper
    private func setupNavi() {
        navigationItem.title = "등록하기"
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(handleDismissTapped), for: .touchUpInside)
        let leftBackButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftBackButton
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        collectionView.register(CategoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.register(RegisterIconCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func itemFilter(category: Category) -> [ItemType] {
        ItemType.allCases.filter {
            $0.id == category.categoryId
        }
    }
}

//MARK: - UICollectionView
extension ItemRegisterController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return itemFilter(category: selectedCategory).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RegisterIconCell else { return UICollectionViewCell() }
        let item = itemFilter(category: selectedCategory)[indexPath.row]
        cell.itemType = item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as! CategoryHeaderView
        header.category = selectedCategory
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RegisterIconCell else { return }
        guard let type = cell.itemType else { return }
        let vc = DetailRegisterController(withSelectedType: type, actionType: .register)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ItemRegisterController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (view.frame.width - 120) / 4, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
}
