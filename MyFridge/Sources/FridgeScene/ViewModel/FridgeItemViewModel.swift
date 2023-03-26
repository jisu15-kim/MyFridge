//
//  FridgeItemViewModel.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/04.
//

import UIKit

class FridgeItemViewModel {
    
    //MARK: - Properties
    var isSelected: Bool?
    
    var item: FridgeItemModel
    
    var itemID: String {
        return item.docID ?? ""
    }
    
    var itemName: String {
        return item.itemName
    }
    
    var itemIcon: UIImage? {
        return UIImage(named: item.itemType.rawValue)
    }
    
    var expireDayGapInt: Int {
        let expireDate = expireDate
        let dateGapInt = daysBetweenDates(expireDate) ?? 0
        return dateGapInt
    }
    
    var expireDDay: String {
        if expireDayGapInt > 0 {
            return "D-\(expireDayGapInt)"
        } else if expireDayGapInt == 0 {
            return "오늘까지"
        } else {
            return "\(-expireDayGapInt)일 지남"
        }
    }
    
    var expireDate: Date {
        let date = calculateExpireDate(item.expireDay, to: item.timestamp) ?? Date()
        return date
    }
    
    var expireInfoText: NSAttributedString {
        let date = calculateExpireDate(item.expireDay, to: item.timestamp) ?? Date()
        let gap = daysBetweenDates(date)
        return expireInfoAttributeText(withValue: gap)
    }
    
    var registedDate: Date {
        return item.timestamp
    }
    
    var category: String {
        return item.category.categoryName
    }
    
    var memoShortText: String {
        return item.memo ?? ""
    }
    
    var memoText: NSAttributedString {
        let memo = item.memo
        
        if memo == "" || memo == nil {
            let text = memoLabelAttributeText(text: "등록한 메모가 없습니다. 클릭해서 메모를 추가해보세요!", font: .systemFont(ofSize: 14), color: .gray)
            return text
        } else {
            let text = memoLabelAttributeText(text: memo!, font: .systemFont(ofSize: 14), color: .label)
            return text
        }
    }
    
    //MARK: - Lifecycle
    init(item: FridgeItemModel) {
        self.item = item
    }
    
    //MARK: - Noti
    func registerUserNotis(notiConfigs: [ItemNotiConfig]) {
        notiConfigs.enumerated().forEach {
            let calendar = Calendar.current
//            let after10Sec = Date().addingTimeInterval(10)
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: $1.date)
            dateComponents.hour = 18
            NotificationManager().setItemNotification(withItemViewModel: self, notiConfig: $1, index: $0, dateComponents: dateComponents)
            print("DEBUG - dateComponents: \(dateComponents)")
        }
    }
    
    //MARK: - Helper
    
    
    func deletePreviousUserNotification() {
        var uids: [String] = []
        item.userNotiData.forEach {
            uids.append($0.uid)
        }
        NotificationManager().deleteItemNotifications(uids: uids)
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
    
    func expireInfoAttributeText(withValue value: Int?) -> NSAttributedString {
        if let value = value {
            // 안전
            if value > 3 {
                let attributedTitle = NSMutableAttributedString(string: "유통기한이", attributes: [.font : UIFont.systemFont(ofSize: 15)])
                attributedTitle.append(NSAttributedString(string: " ✅ \(value)일", attributes: [.font : UIFont.boldSystemFont(ofSize: 15)]))
                attributedTitle.append(NSAttributedString(string: " 남았어요", attributes: [.font : UIFont.systemFont(ofSize: 15)]))
                return attributedTitle
            // 경고
            } else if value > 0 {
                let attributedTitle = NSMutableAttributedString(string: "유통기한이", attributes: [.font : UIFont.systemFont(ofSize: 15)])
                attributedTitle.append(NSAttributedString(string: " ⚠️ \(value)일", attributes: [.font : UIFont.boldSystemFont(ofSize: 15)]))
                attributedTitle.append(NSAttributedString(string: " 남았어요", attributes: [.font : UIFont.systemFont(ofSize: 15)]))
                return attributedTitle
            } else if value == 0 {
                let attributedTitle = NSMutableAttributedString(string: "유통기한이", attributes: [.font : UIFont.systemFont(ofSize: 15)])
                attributedTitle.append(NSAttributedString(string: " 🔥오늘", attributes: [.font : UIFont.boldSystemFont(ofSize: 15)]))
                attributedTitle.append(NSAttributedString(string: " 까지에요‼️", attributes: [.font : UIFont.systemFont(ofSize: 15)]))
                return attributedTitle
            } else if value > -4 {
                let attributedTitle = NSMutableAttributedString(string: "유통기한이", attributes: [.font : UIFont.systemFont(ofSize: 15)])
                attributedTitle.append(NSAttributedString(string: " ⚠️ \(-value)일", attributes: [.font : UIFont.boldSystemFont(ofSize: 15)]))
                attributedTitle.append(NSAttributedString(string: " 지났어요. 주의하세요", attributes: [.font : UIFont.systemFont(ofSize: 15)]))
                return attributedTitle
            } else {
                let attributedTitle = NSMutableAttributedString(string: "유통기한이", attributes: [.font : UIFont.systemFont(ofSize: 15)])
                attributedTitle.append(NSAttributedString(string: " 🚫 \(-value)일", attributes: [.font : UIFont.boldSystemFont(ofSize: 15)]))
                attributedTitle.append(NSAttributedString(string: " 지났어요.", attributes: [.font : UIFont.systemFont(ofSize: 15)]))
                return attributedTitle
            }
        } else {
            let attributedTitle = NSMutableAttributedString(string: "데이터 오류", attributes: [.font : UIFont.systemFont(ofSize: 15)])
            return attributedTitle
        }
    }
    
    func memoLabelAttributeText(text: String, font: UIFont, color: UIColor) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: text, attributes: [.font :font, .foregroundColor: color])
        return attributedTitle
    }
    
    func deleteItem(completion: @escaping (Bool) -> Void) {
        Network().deleteItem(itemID: itemID, completion: completion)
    }
}
