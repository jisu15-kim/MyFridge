//
//  NotificationCenter.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/10.
//

import UIKit

class NotificationManager {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func setItemNotification(withItemViewModel viewModel: FridgeItemViewModel, notiConfig: ItemNotiConfig, index: Int, dateComponents: DateComponents) {
        // 콘텐츠를 만듬
        let content = UNMutableNotificationContent()
        content.title = "냉장고 유통기한 알림"
        content.body = "\(viewModel.itemName)의 유통기한이 \(notiConfig.dayOffset)일 남았어요! \n어떻게 요리할지 냉장고AI에게 물어볼까요?"

        // DateComponents 를 활용해 트리거 만듬
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        // 요청을 만듬
        let request = UNNotificationRequest(identifier: notiConfig.uid, content: content, trigger: trigger)

        // 요청을 센터에 등록
        notificationCenter.add(request)
    }
    
    
    func getAllNotifications() {
        notificationCenter.getPendingNotificationRequests { requests in
            dump(requests)
        }
    }
    
    func deleteAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        getAllNotifications()
    }
    
    func deleteItemNotifications(uids: [String]) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: uids)
    }
    
    // 10초 뒤에 알림이 오는 샘플 노티
    func setSampleNotification(withItemViewModel viewModel: FridgeItemViewModel, notiConfig: ItemNotiConfig, index: Int, dateComponents: DateComponents) {
        // 콘텐츠를 만듬
        let content = UNMutableNotificationContent()
        content.title = "유통기한 알림"
        content.body = "\(viewModel.itemName)의 유통기한이 \(notiConfig.dayOffset)일 남았어요! \n어떻게 요리할지 냉장고AI에게 물어볼까요?"
        content.badge = 1

        // 트리거를 만듬

        // DateComponents 를 활용해 트리거 만듬
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        // 요청을 만듬
        let request = UNNotificationRequest(identifier: notiConfig.uid, content: content, trigger: trigger)

        // 요청을 센터에 등록
        notificationCenter.add(request)
    }
}
