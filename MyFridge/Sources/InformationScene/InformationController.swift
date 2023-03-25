//
//  InfomationController.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/22.
//

import UIKit
import SnapKit
import Combine

private let itemCellIdentifier = "FridgeItemCell"

protocol InformationControllerDelegate: AnyObject {
    func askToAIButtonTapped()
}

class InformationController: UIViewController {
    //MARK: - Properties
    let viewModel: FridgeViewModel
    private var subscription = Set<AnyCancellable>()
    
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "☝️냉장고 속 재료를 선택✨"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 20, right: 10)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    lazy var ingrediendAskView = IngredientAskView(viewController: self)
    let emptyView = EmptyFridgeView()
    
    //MARK: - Lifecycle
    init() {
        viewModel = FridgeViewModel()
        super.init(nibName: nil, bundle: nil)
        print("SuperViewModel : \(viewModel)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        setupUI()
        bind()
        setupCollectionView()
        configureEmptyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchItems()
    }
    //MARK: - Bind
    func bind() {
        viewModel.items
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
                self?.configureEmptyView()
            }.store(in: &subscription)
    }
    
    //MARK: - Selector
    
    //MARK: - Functions
    
    private func configureEmptyView() {
        if viewModel.items.value.isEmpty {
            emptyView.isHidden = false
            guideLabel.isHidden = true
        } else {
            emptyView.isHidden = true
            guideLabel.isHidden = false
        }
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .mainGrayBackground
        collectionView.register(FridgeItemCell.self, forCellWithReuseIdentifier: itemCellIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupNavi() {
        navigationItem.title = "뭐해먹지?"
    }
    
    func setupUI() {
        view.backgroundColor = .mainGrayBackground
        
        view.addSubview(guideLabel)
        guideLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).inset(-12)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(150)
        }
        
        view.addSubview(ingrediendAskView)
        ingrediendAskView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(collectionView.snp.bottom).inset(-20)
            $0.bottom.equalToSuperview()
        }
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(400)
            emptyView.isHidden = true
        }
        
        ingrediendAskView.delegate = self
    }
}

extension InformationController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellIdentifier, for: indexPath) as? FridgeItemCell else { return UICollectionViewCell() }
        let selectedItems = self.viewModel.selectedItem
        let item = viewModel.items.value[indexPath.row]
        let cellViewModel = FridgeItemViewModel(item: item)
        
        // Selected Item 이라면
        selectedItems.value.forEach {
            if $0.docID == item.docID {
                cellViewModel.isSelected = true
            }
        }
        cell.cellViewModel = cellViewModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? FridgeItemCell,
              let viewModel = cell.cellViewModel else { return }
        let item = viewModel.item
        
        if viewModel.isSelected == nil || viewModel.isSelected == false {
            viewModel.isSelected = true
        } else {
            viewModel.isSelected = false
        }
        cell.configureIsSelected()
        
        let items = self.viewModel.selectedItem
        if items.value.contains(where: { $0.docID == item.docID }) {
            items.value.removeAll(where: { $0.docID == item.docID })
        } else {
            items.value.append(item)
        }
    }
}

extension InformationController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = view.frame.width * 0.4
        return CGSize(width: cellWidth, height: 120)
    }
}

extension InformationController: InformationControllerDelegate {
    func askToAIButtonTapped() {
        let vm = AIChatViewModel(items: viewModel.selectedItem.value)
        let vc = AIChatViewController(viewModel: vm)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
