//
//  RegisterController.swift
//  MyFridge
//
//  Created by 김지수 on 2023/02/28.
//

import UIKit

private let reuseIdentifier = "RegisterIconCell"
private let headerIdentifier = "CategoryHeaderView"


class CategoryRegisterController: UIViewController {
    //MARK: - Properties
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 35
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 5, left: 25, bottom: 5, right: 25)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavi()
        setupUI()
        setupCollectionView()
    }
    //MARK: - Selector
    @objc func handleDismissTapped() {
        dismiss(animated: true)
    }
    
    //MARK: - Helper
    private func setupNavi() {
        navigationItem.title = "등록하기"
        let backBtn = UIBarButtonItem(title: "닫기", style: .done, target: self, action: #selector(handleDismissTapped))
        navigationItem.leftBarButtonItem = backBtn
        // 스와이프 백 제스쳐
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
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
    
    private func findCellAtIndex(withIndexPath index: IndexPath) -> RegisterIconCell {
        guard let cell = collectionView.cellForItem(at: index) as? RegisterIconCell else { return RegisterIconCell() }
        return cell
    }
}

//MARK: - UICollectionView
extension CategoryRegisterController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Category.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RegisterIconCell else { return UICollectionViewCell() }
        cell.category = Category.allCases[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as! CategoryHeaderView
        header.configure()
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let type = findCellAtIndex(withIndexPath: indexPath).category else { return }
        let vc = ItemRegisterController(category: type)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CategoryRegisterController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (view.frame.width - 120) / 3, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 300)
    }
}
