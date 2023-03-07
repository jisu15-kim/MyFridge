//
//  Extension.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/02.
//

import UIKit

extension UIView {
    func setViewShadow(backView: UIView) {
        backView.layer.masksToBounds = false
        layer.masksToBounds = false
        layer.shadowOpacity = 0.2
        layer.shadowColor = UIColor.mainForeGround.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 5
    }
}

extension Encodable {
    /// Object to Dictionary
    /// cf) Dictionary to Object: JSONDecoder().decode(Object.self, from: dictionary)
    var asDictionary: [String: Any]? {
        guard let object = try? JSONEncoder().encode(self),
              let dictinoary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: Any] else { return nil }
        return dictinoary
    }
}


//MARK: - 키보드 바깥 Tap Hide 처리
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIResponder {

    private struct Static {
        static weak var responder: UIResponder?
    }

    /// Finds the current first responder
    /// - Returns: the current UIResponder if it exists
    static func currentFirst() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }

    @objc private func _trap() {
        Static.responder = self
    }
}

extension UITextField {
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
    func addleftimage(image:UIImage) {
            let leftimage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            leftimage.image = image
            self.leftView = leftimage
            self.leftViewMode = .always
        }
}

//MARK: - 키보드 올릴 때 뷰 같이 올라가도록
//extension UIViewController {
//
//    // 옵저버 세팅
//    func setKeyboardObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object:nil)
//    }
//
//    @objc func keyboardWillShow( notification: NSNotification) {
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//
//            // 기본 상태일 경우
//            if self.view.frame.origin.y == self.view.window?.frame.origin.y {
//                UIView.animate(withDuration: 0.5) {
//                    // 네비게이션바는 냅두고 올라가도록
//                    let offsetY = self.view.frame.origin.y - keyboardHeight
//                    self.view.frame.origin.y = offsetY
//                }
//            } else {
//                // 이미 키보드가 올라가있는 경우
//                let offsetY = self.view.frame.origin.y - keyboardHeight
//                self.view.frame.origin.y = offsetY
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            UIView.animate(withDuration: 0.5) {
//                guard let offset = self.view.window?.frame.origin.y else { return }
//                self.view.frame.origin.y = offset
//            }
//        }
//    }
//}
