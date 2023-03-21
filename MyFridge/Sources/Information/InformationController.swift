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

class InformationController: UIViewController {
    //MARK: - Properties
    private let viewModel: FridgeViewModel
    private var subscription = Set<AnyCancellable>()
    
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "1. 냉장고 속 재료를 선택✨"
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
    
    var selectedItem = CurrentValueSubject<[FridgeItemModel], Never>([])
    
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
        setupNavi()
        setupUI()
        bind()
        setupCollectionView()
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
            }.store(in: &subscription)
    }
    
    //MARK: - Selector
    
    //MARK: - Functions
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
    }
}

extension InformationController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellIdentifier, for: indexPath) as? FridgeItemCell else { return UICollectionViewCell() }
        let item = viewModel.items.value[indexPath.row]
        let cellViewModel = FridgeItemViewModel(item: item)
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
        
        if selectedItem.value.contains(where: { $0.docID == item.docID }) {
            selectedItem.value.removeAll(where: { $0.docID == item.docID })
        } else {
            selectedItem.value.append(item)
        }
    }
}

extension InformationController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = view.frame.width * 0.4
        return CGSize(width: cellWidth, height: 120)
    }
}
