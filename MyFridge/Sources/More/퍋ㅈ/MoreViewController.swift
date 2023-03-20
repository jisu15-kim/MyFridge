//
//  PreferenceController.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/20.
//

import UIKit

private let identifier = "MoreViewCell"

class MoreViewController: UIViewController {
    //MARK: - Properties
    let viewModel: MoreViewModel
    lazy var topUserInfoView: TopUserInfoView = {
        let view = TopUserInfoView(user: viewModel.user)
        view.delegate = self
        return view
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        let vc = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return vc
    }()
    
    //MARK: - Selector
    
    //MARK: - Lifecycle
    init(user: UserModel) {
        viewModel = MoreViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "더보기"
        setupUI()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    private func setupCollectionView() {
        collectionView.register(MoreViewCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .mainGrayBackground
    }
    
    private func setupUI() {
        view.backgroundColor = .mainGrayBackground
        
        view.addSubview(topUserInfoView)
        topUserInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(100)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(topUserInfoView.snp.bottom).inset(-20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension MoreViewController: TouchUserInfoViewDelegate {
    func editUserInfoViewTapped() {
        print("Edit Profile Tapped")
    }
}

extension MoreViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MoreViewConfigureationType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? MoreViewCell else { return UICollectionViewCell() }
        cell.type = MoreViewConfigureationType.allCases[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedType = MoreViewConfigureationType.allCases[indexPath.row]
        
        switch selectedType {
        case .setting:
            let vc = SettingController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            print("DEBUG - \(selectedType) 눌림")
        }
    }
}

extension MoreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}
