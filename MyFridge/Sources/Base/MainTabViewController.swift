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
    var user: UserModel?
    var uid: String?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserAndConfigureUI()
        delegate = self
    }
    
    //MARK: - API
    func authenticateUserAndConfigureUI() {
        if let authUser = Auth.auth().currentUser {
            uid = authUser.uid
            Network().fetchUser { [weak self] user in
                if let user = user {
                    if user.termsConfirmed == true {
                        print(user.termsConfirmed)
                        print("DEBUG: 로그인 되었습니다")
                        self?.user = user
                        self?.configureViewController()
                        self?.selectedIndex = 0
                        self?.uiTabBarSetting()
                    } else {
                        // 동의 뷰로 이동하기
                        let vc = UserConfirmController(user: user, uid: authUser.uid)
                        vc.delegate = self
                        guard let nav = self?.templateNavigationController(nil, viewController: vc) else { return }
                        nav.modalPresentationStyle = .fullScreen
                        self?.present(nav, animated: true)
                    }
                } else {
                    print("DEBUG: 로그인 상태가 아닙니다")
                    self?.showLoginView()
                }
            }
        } else {
            print("DEBUG: 로그인 상태가 아닙니다")
            self.showLoginView()
        }
    }
    
    func showLoginView() {
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: LoginController())
            nav.modalPresentationStyle = .fullScreen
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true)
        }
    }
    
    func fetchUser() {
        Network().fetchUser { [weak self] user in
            self?.user = user
        }
    }
    
    //MARK: - Helper
    func configureViewController() {
        let fridge = FridgeController()
        fridge.authDelegate = self
        let nav1 = templateNavigationController("archivebox.fill", viewController: fridge)
        
        let dummy = UIViewController()
        let nav2 = templateNavigationController("plus", viewController: dummy)
        
        let info = InformationController()
        let nav3 = templateNavigationController("network", viewController: info)
        
        guard let user = user else { return }
        let preference = MoreViewController(user: user)
        let nav4 = templateNavigationController("ellipsis", viewController: preference)
        
        viewControllers = [nav1, nav2, nav3, nav4]
    }
    
    func templateNavigationController(_ image: String?, viewController:UIViewController) -> UINavigationController {
        let nav = MainNaviViewController(rootViewController: viewController)
        if let image = image {
            nav.tabBarItem.image = UIImage(systemName: image)
        }
        
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
            //            tabBar.isTranslucent = true
            tabBar.tintColor = .mainAccent
            tabBar.backgroundColor = .mainGrayBackground
            tabBar.barStyle = .default
            tabBar.layer.masksToBounds = false
            tabBar.layer.shadowColor = UIColor.mainForeGround.cgColor
            tabBar.layer.shadowOpacity = 0.2
            tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
            tabBar.layer.shadowRadius = 6
            tabBar.isTranslucent = true
        }
    }
    
    func logout() {
        guard let user = user else { return }
        NotificationManager().deleteAllNotifications()
        UserDefaults.standard.setthisAccoutFirstLogin(value: true)
        AuthService.shared.logUserOut(user: user) { [weak self] in
            self?.authenticateUserAndConfigureUI()
        }
    }
}

extension MainTabViewController: AuthDelegate {
    func didFinishedUpdateUserConfirm() {
        authenticateUserAndConfigureUI()
    }
    
    func logUserOut(user: UserModel) {
        NotificationManager().deleteAllNotifications()
        AuthService.shared.logUserOut(user: user) { [weak self] in
            self?.authenticateUserAndConfigureUI()
        }
    }
}

extension MainTabViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController), index == 1 {
            
            guard let navi = tabBarController.viewControllers?[0] as? MainNaviViewController else { return false }
            navi.addButtonTapped()
            return false
        } else {
            // 다른 탭바 아이템인 경우
            // 뷰 전환을 진행함
            return true
        }
    }
}
