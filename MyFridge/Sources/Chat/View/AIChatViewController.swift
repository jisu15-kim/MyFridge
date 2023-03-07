//
//  ChatViewController.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/02.
//

import UIKit
import SnapKit

private let reuseIdentifier = "ChatBubbleCell"

class AIChatViewController: UIViewController {
    
    //MARK: - Properties
    let dummyChats: [AIChatModel] = [
        AIChatModel(content: "DummyDatㅇㄹㄴaOhyesㄷㅎㄹㅁㅇㅍㅎㄹㄴㅇㅎㅁㄷㄱㅎㅇㄹ허ㅏㅜㄹㅁㄹ어ㅣㅍㅁ어", chatType: .ai),
        AIChatModel(content: "Dummyㅇㅇ", chatType: .ai),
        AIChatModel(content: "Dummy", chatType: .my),
        AIChatModel(content: "Dum", chatType: .ai),
        AIChatModel(content: "Dummyㄱㄷㄱㄴㄹㅇㄴ", chatType: .my)
    ]
    let viewModel: AIChatViewModel
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .mainGrayBackground
        return cv
    }()
    
    //MARK: - Lifecycle
    init(viewModel: AIChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupCollectionView()
    }
    
    //MARK: - Helper
    func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        collectionView.register(ChatBubbleCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

//MARK: - CollectionViewDataSource / Delegate
extension AIChatViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyChats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ChatBubbleCell else { return UICollectionViewCell() }
        let cellViewModel = ChatBubbleCellViewModel(data: dummyChats[indexPath.row])
        cell.viewModel = cellViewModel
        return cell
    }
}

extension AIChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = ChatBubbleCellViewModel(data: dummyChats[indexPath.row])
        let flexibleHeight = viewModel.getCellSize(font: .systemFont(ofSize: 14)).height
        return CGSize(width: collectionView.frame.width, height: flexibleHeight)
    }
}
