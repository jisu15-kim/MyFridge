//
//  CheckApiCallCount.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/28.
//

import UIKit

extension UIViewController {
    // API Call Count가 유효하다면, escaping
    func checkAPICallCount(completion: @escaping () -> Void) {
        if ApiCallCounter.shared.checkShouldCallApi() == true {
            completion()
        } else {
            let alert = UIAlertController(title: "AI 질문 횟수 초과", message: "오늘 AI에게 질문할 수 있는 횟수를 초과했어요😢 내일 다시 시도해주세요 !", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default)
            alert.addAction(confirm)
            self.present(alert, animated: true)
        }
    }
}
