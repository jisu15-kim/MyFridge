//
//  IngredientAskController.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/22.
//

import UIKit
import SnapKit
import Combine

private let cellIdentifier = "SelectedItemCell"
private let footerIdentifier = "SelectedViewFooterView"

class IngredientAskView: UIView {
    //MARK: - Properties
    weak var delegate: InformationControllerDelegate?
    private let superView: InformationController
    
    private var subscription = Set<AnyCancellable>()
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "AI에게 요리를 추천받아요👍"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = CustomFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 20, right: 10)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    //MARK: - Lifecycle
    
    init(viewController: InformationController) {
        self.superView = viewController
        super.init(frame: .zero)
        setupUI()
        bind()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    private func bind() {
        superView.viewModel.selectedItem
            .receive(on: RunLoop.main)
            .sink { [weak self] model in
                print("bind")
                self?.collectionView.reloadData()
                self?.isHidden = model.isEmpty
            }.store(in: &subscription)
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .mainGrayBackground
        collectionView.register(SelectedItemCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(SelectedViewFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupUI() {
        addSubview(guideLabel)
        guideLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).inset(-12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension IngredientAskView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return superView.viewModel.selectedItem.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? SelectedItemCell else { return UICollectionViewCell() }
        let item = superView.viewModel.selectedItem.value[indexPath.row]
        let itemViewModel = FridgeItemViewModel(item: item)
        cell.itemViewModel = itemViewModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerIdentifier, for: indexPath) as? SelectedViewFooterView else { return UICollectionReusableView() }
        footer.delegate = self.delegate
        return footer
    }
}

extension IngredientAskView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = superView.viewModel.selectedItem.value[indexPath.row]
        let offsetText = item.itemName
        let measurementLabel = UILabel(frame: .zero)
        measurementLabel.text = offsetText
        measurementLabel.font = .boldSystemFont(ofSize: 18)
        let measurementLabelSize = measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let width = measurementLabelSize.width + CGFloat(68)
        return CGSize(width: width, height: 50)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}
