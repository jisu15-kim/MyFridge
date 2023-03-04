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
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 5
        layer.cornerRadius = 10
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
