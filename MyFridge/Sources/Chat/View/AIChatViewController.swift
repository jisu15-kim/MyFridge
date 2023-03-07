//
//  ChatViewController.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/02.
//

import UIKit
import SnapKit
import Combine

private let reuseIdentifier = "ChatBubbleCell"
private let headerIdentifier = "ChatHeader"

class AIChatViewController: UIViewController {
    
    //MARK: - Properties
    let viewModel: AIChatViewModel
    let keyword: String
    var subscription = Set<AnyCancellable>()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .mainGrayBackground
        return cv
    }()
    
    //MARK: - Lifecycle
    init(viewModel: AIChatViewModel) {
        self.viewModel = viewModel
        self.keyword = viewModel.makeKeyword()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
        tryRequest()
        setupCollectionView()
    }
    //MARK: - Bind
    private func bind() {
        viewModel.chats
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }.store(in: &subscription)
        
        viewModel.isAIProcessing
            .receive(on: RunLoop.main)
            .sink { [weak self] isProcessing in
                self?.bindProcessingCell(isProcessing: isProcessing)
            }.store(in: &subscription)
    }
    
    //MARK: - API
    private func tryRequest() {
        viewModel.isAIProcessing.send(true)
        viewModel.askToAI(keyword: keyword) { [weak self] response in
            self?.viewModel.isAIProcessing.send(false)
        }
    }
    
    //MARK: - Helper
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        collectionView.register(ChatBubbleCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ChatHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func bindProcessingCell(isProcessing: Bool) {
        viewModel.bindAndReturnAIProcessingString(value: isProcessing)
    }
}

//MARK: - CollectionViewDataSource / Delegate
extension AIChatViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getChatsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ChatBubbleCell else { return UICollectionViewCell() }
        let cellViewModel = viewModel.getChatViewModel(indexPath: indexPath)
        cell.viewModel = cellViewModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as? ChatHeader else { return UICollectionReusableView() }
        header.delegate = self
        return header
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AIChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = viewModel.getChatViewModel(indexPath: indexPath)
        let flexibleHeight = viewModel.getCellSize().height
        return CGSize(width: collectionView.frame.width, height: flexibleHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
}

//MARK: - AIChatDelegate
extension AIChatViewController: AIChatDelegate {
    func viewDismissTapped() {
        self.dismiss(animated: true)
    }
}
