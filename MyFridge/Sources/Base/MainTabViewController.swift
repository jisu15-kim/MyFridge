//
//  MainTabViewController.swift
//  MyFridge
//
//  Created by 김지수 on 2023/02/28.
//

import UIKit

class MainTabViewController: UITabBarController {

    //MARK: - Properties
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureViewController()
        uiTabBarSetting()
    }
    
    //MARK: - API
    
    //MARK: - Helper
    func configureViewController() {
        let fridge = FridgeController()
        let nav1 = templateNavigationController("refrigerator.fill", viewController: fridge)
        
        let explore = UIViewController()
        let nav2 = templateNavigationController("info.circle.fill", viewController: explore)
        
        viewControllers = [nav1, nav2]
    }
    
    func templateNavigationController(_ image: String, viewController:UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem.image = UIImage(systemName: image)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        nav.navigationBar.standardAppearance = appearance;
        nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
        
        return nav
    }
    
    func uiTabBarSetting() {
        if #available(iOS 15.0, *){
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
