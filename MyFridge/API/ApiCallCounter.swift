//
//  ApiCallCounter.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/28.
//

import Foundation

class ApiCallCounter {
    static let shared = ApiCallCounter()
    private init() {}
    
    //MARK: - API 호출 제한
    // 호출 제한을 저장하는 UserDefault 키
    let apiCallCountKey = "apiCallCount"
    
    // 호출 제한
    let apiCallLimit = 25
    
    // 호출 제한 확인하기
    func checkShouldCallApi() -> Bool {
        let currentCount = getAPICallCount()
        if currentCount > 0 {
            return true
        } else {
            return false
        }
    }
    
    // 호출 횟수 가져오기
    func getAPICallCount() -> Int {
        return UserDefaults.standard.integer(forKey: apiCallCountKey)
    }
    
    // 호출 횟수 증가하기
    func decreaseAPICallCount() {
        let currentCount = getAPICallCount()
        UserDefaults.standard.set(currentCount - 1, forKey: apiCallCountKey)
    }
    
    //MARK: - API 호출 횟수 초기화
    
    // 새로운 날이 되면 호출 제한 초기화하기
    func resetAPICallCountIfNeeded() {
        let currentDate = Date()
        let userDefaults = UserDefaults.standard
        
        // 마지막으로 초기화한 날짜 가져오기
        let lastResetDate = userDefaults.object(forKey: "lastResetDate") as? Date ?? Date(timeIntervalSinceNow: -86400)
        
        let calendar = Calendar.current
        let currentDateComponent = calendar.dateComponents([.year, .month, .day], from: currentDate)
        let lastResetDateComponent = calendar.dateComponents([.year, .month, .day], from: lastResetDate)
        
        // 마지막으로 초기화한 날짜가 없거나, 다음 날이 되었으면 초기화하기
        if currentDateComponent != lastResetDateComponent {
            resetAPICallCount()
            userDefaults.set(currentDate, forKey: "lastResetDate")
        }
    }
    // 호출 제한 초기화 함수
    func resetAPICallCount() {
        UserDefaults.standard.set(apiCallLimit, forKey: apiCallCountKey)
    }
}

