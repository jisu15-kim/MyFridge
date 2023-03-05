//
//  ChatViewController.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/02.
//

import UIKit
import SnapKit

class AIChatViewController: UIViewController {
    
    //MARK: - Properties
    let viewModel: AIChatViewModel
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    let answerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
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
    }
    
    //MARK: - Helper
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(questionLabel)
        questionLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        view.addSubview(answerLabel)
        answerLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(questionLabel.snp.bottom).inset(-20)
        }
        
        let keyword = viewModel.makeKeyword()
        questionLabel.text = keyword
        
        viewModel.askToAI(keyword: keyword) { [weak self] result in
            print(result)
            self?.answerLabel.text = result
            self?.answerLabel.sizeToFit()
        }
    }
}
