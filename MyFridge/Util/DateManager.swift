//
//  DateManager.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/10.
//

import UIKit

class DateManager {
    
    func getUserNotiUid(expireDay: Int, offsetDate: Date) -> [ItemNotiConfig] {
        // 알림을 줄 날짜 기준
        let offset = [10, 5, 3, 1, 0]
        // 유통기한 날짜
        let expireDate = calculateExpireDate(expireDay, to: offsetDate) ?? Date()
        // 남은 날짜
        let expireDDay = daysBetweenDates(expireDate) ?? 0
        // 실제 알림을 줄 날짜 계산
        let filteredOffset = offset.filter({ $0 < expireDDay })
        print("DEBUG - \(filteredOffset)일 남았을 때 알림을 보냅니다")
        // 알림을 보낼 날짜
        var notiConfigs: [ItemNotiConfig] = []
        
        filteredOffset.enumerated().forEach {
            let uid = UUID().uuidString
            let notificationDate = getNotificationDate(from: expireDate, offset: $1)
            let config = ItemNotiConfig(date: notificationDate, dayOffset: filteredOffset[$0], uid: uid)
            notiConfigs.append(config)
        }
        dump(notiConfigs)
        return notiConfigs
    }
    
    func getNotificationDate(from expireDate: Date, offset: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -offset, to: expireDate)!
    }
    
    func calculateExpireDate(_ days: Int, to date: Date) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.day = days
        
        let calendar = Calendar.current
        return calendar.date(byAdding: dateComponents, to: date)
    }
    
    func daysBetweenDates(_ date: Date) -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: date))
        return components.day
    }
}
