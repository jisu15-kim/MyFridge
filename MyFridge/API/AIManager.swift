//
//  AIManager.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/02.
//

import Foundation
import Alamofire

class AIManager {
    func askRecommandStoreWay(item: ItemType, type: KeepType) {
        print("DEGUT - \(item.itemName), \(type.rawValue)")
        let text = "\(item.itemName)을 오래 \(type.rawValue)보관 하기 위한 가장 효율적인 방법 세가지만 간결하게 알려줘"
        let baseUrl = Secret.baseUrl
        let body = OpenAICompletionsBody(model: "text-davinci-003", prompt: text, temperature: 0.7, max_tokens: 300)
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Secret.token)"]
        
        AF.request(baseUrl + "completions", method: .post, parameters: body, encoder: .json, headers: headers)
            .responseDecodable(of: OpenAICompletionsResponse.self) { response in
                print(response.result)
            }
    }
}

struct OpenAICompletionsBody: Encodable {
    let model: String
    let prompt: String
    let temperature: Float?
    let max_tokens: Int
}

struct OpenAICompletionsResponse: Decodable {
    let id: String
    let choices: [OpenAIcompletionsOptions]
}

struct OpenAIcompletionsOptions: Decodable {
    let text: String
}
