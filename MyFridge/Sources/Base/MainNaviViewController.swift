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
        appearance.backgroundColor = .systemBackground
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = self.navigationBar.standardAppearance
    }
}
