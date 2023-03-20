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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserAndConfigureUI()
    }
    
    //MARK: - API
    func authenticateUserAndConfigureUI() {
        if let authUser = Auth.auth().currentUser {
//            do {
//                try Auth.auth().signOut()
//            }
//
//            catch let error {
//                print("DEBUG: 로그아웃에 실패했어요 \(error)")
//            }
            
            
            Network().fetchUser { [weak self] user in
                if user.termsConfirmed == true {
                    print("DEBUG: 로그인 되었습니다")
                    self?.user = user
                    self?.configureViewController()
                    self?.uiTabBarSetting()
                } else {
                    // 동의 뷰로 이동하기
                    let vc = UserConfirmController(user: user, uid: authUser.uid)
                    vc.delegate = self
                    guard let nav = self?.templateNavigationController(nil, viewController: vc) else { return }
                    nav.modalPresentationStyle = .fullScreen
                    self?.present(nav, animated: true)
                }
            }
        } else {
            print("DEBUG: 로그인 상태가 아닙니다")
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }
    }
    
    //MARK: - Helper
    func configureViewController() {
        let fridge = FridgeController()
        fridge.authDelegate = self
        let nav1 = templateNavigationController("refrigerator.fill", viewController: fridge)
        
        let explore = UIViewController()
        let nav2 = templateNavigationController("info.circle.fill", viewController: explore)
        
        guard let user = user else { return }
        let preference = MoreViewController(user: user)
        let nav3 = templateNavigationController("ellipsis", viewController: preference)
        
        viewControllers = [nav1, nav2, nav3]
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
}

extension MainTabViewController: AuthDelegate {
    func didFinishedUpdateUserConfirm() {
        authenticateUserAndConfigureUI()
    }
    
    func logUserOut(user: UserModel) {
        DispatchQueue.global().async {
            NotificationManager().deleteAllNotifications()
            AuthService.shared.logUserOut(user: user) { [weak self] in
                self?.authenticateUserAndConfigureUI()
            }
        }
    }
}
