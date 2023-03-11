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
        layout.minimumInteritemSpacing = 20
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 50, left: 0, bottom: 30, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .mainGrayBackground
        return cv
    }()
    
    lazy var processingView: UIView = {
        let view = UIView()
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.text = "냉장고가 입력중이에요✨"
        label.textColor = .label
        view.addSubview(label)
        view.backgroundColor = .mainReverseLabel
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return view
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
        
        bind()
        setupUI()
        setupCollectionView()
        tryRequest()
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
                self?.bindProcessingView(isProcessing: isProcessing)
            }.store(in: &subscription)
    }
    
    //MARK: - API
    private func tryRequest() {
        viewModel.askToAI(keyword: keyword) { _ in return }
    }
    
    //MARK: - Helper
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupCollectionView() {
        collectionView.register(ChatBubbleCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ChatHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    private func bindProcessingView(isProcessing: Bool) {
        // 코드 수정이 필요한 부분 ..
        if isProcessing == true {
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
                    let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                    self.view.addSubview(self.processingView)
                    self.processingView.isHidden = false
                    self.processingView.snp.makeConstraints {
                        $0.leading.trailing.equalToSuperview()
                        $0.top.equalTo(self.view.snp.top).inset(statusBarHeight + 80)
                        $0.height.equalTo(20)
                    }
                }
            }
        } else {
            self.processingView.isHidden = true
        }
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
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return CGSize(width: collectionView.frame.width, height: 80 + statusBarHeight)
    }
}

//MARK: - AIChatDelegate
extension AIChatViewController: AIChatDelegate {
    func viewDismissTapped() {
        self.dismiss(animated: true)
    }
}
