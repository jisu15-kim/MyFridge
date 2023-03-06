//
//  MainNaviViewController.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/01.
//

import UIKit

class MainNaviViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainGrayBackground
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = self.navigationBar.standardAppearance
        navigationBar.tintColor = .mainAccent
        setupBarButtons()
    }
    
    private func setupBarButtons() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        let leftBackButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftBackButton
    }
    
    @objc private func handleBackTapped() {
        navigationController?.popViewController(animated: true)
    }
}
