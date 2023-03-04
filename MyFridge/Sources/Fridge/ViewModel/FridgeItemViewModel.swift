//
//  FridgeItemViewModel.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/04.
//

import UIKit

class FridgeItemViewModel {
    
    //MARK: - Properties
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
    
    var expireDDay: String {
        return "D-\(item.expireDay)"
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
    
    //MARK: - Helper
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
        let attributedTitle = NSMutableAttributedString(string: "유통기한이", attributes: [.font : UIFont.systemFont(ofSize: 15)])
        attributedTitle.append(NSAttributedString(string: " ✅ \(value ?? 0)일", attributes: [.font : UIFont.boldSystemFont(ofSize: 15)]))
        attributedTitle.append(NSAttributedString(string: " 남았어요", attributes: [.font : UIFont.systemFont(ofSize: 15)]))
        return attributedTitle
    }
    
    func memoLabelAttributeText(text: String, font: UIFont, color: UIColor) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: text, attributes: [.font :font, .foregroundColor: color])
        return attributedTitle
    }
    
    func deleteItem(completion: @escaping (Bool) -> Void) {
        Network().deleteItem(itemID: itemID, completion: completion)
    }
}
