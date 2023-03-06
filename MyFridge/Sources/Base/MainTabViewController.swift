//
//  MainTabViewController.swift
//  MyFridge
//
//  Created by 김지수 on 2023/02/28.
//

import UIKit
import Firebase

class MainTabViewController: UITabBarController {

    //MARK: - Properties
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserAndConfigureUI()
    }
    
    //MARK: - API
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            print("DEBUG: 로그인 상태가 아닙니다")
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        } else {
            print("DEBUG: 로그인 되었습니다")
            configureViewController()
            uiTabBarSetting()
        }
    }
    
    //MARK: - Helper
    func configureViewController() {
        let fridge = FridgeController()
        fridge.authDelegate = self
        let nav1 = templateNavigationController("refrigerator.fill", viewController: fridge)
        
        let explore = UIViewController()
        let nav2 = templateNavigationController("info.circle.fill", viewController: explore)
        
        viewControllers = [nav1, nav2]
    }
    
    func templateNavigationController(_ image: String, viewController:UIViewController) -> UINavigationController {
        let nav = MainNaviViewController(rootViewController: viewController)
        nav.tabBarItem.image = UIImage(systemName: image)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainGrayBackground
        nav.navigationBar.standardAppearance = appearance;
        nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
        
        nav.navigationBar.tintColor = .mainAccent
        return nav
    }
    
    func uiTabBarSetting() {
        if #available(iOS 15.0, *){
//            let appearance = UITabBarAppearance()
//            appearance.configureWithDefaultBackground()
//            appearance.backgroundColor = .mainGrayBackground
//            tabBar.standardAppearance = appearance
//            tabBar.scrollEdgeAppearance = appearance
//            tabBar.tintColor = .mainAccent
//            tabBar.isTranslucent = true
            tabBar.backgroundColor = .mainGrayBackground
            tabBar.barStyle = .default
            tabBar.layer.masksToBounds = false
            tabBar.layer.shadowColor = UIColor.mainForeGround.cgColor
            tabBar.layer.shadowOpacity = 0.2
            tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
            tabBar.layer.shadowRadius = 6
        }
    }
}

extension MainTabViewController: AuthDelegate {
    func logUserOut() {
        authenticateUserAndConfigureUI()
    }
}
