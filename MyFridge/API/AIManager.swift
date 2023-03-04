//
//  AIManager.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/02.
//

import Foundation
import Alamofire

class AIManager {
    func askRecommandStoreWay(keyword: String, completion: @escaping (String) -> Void) {
        let baseUrl = Secret.baseUrl
        let body = OpenAICompletionsBody(model: "text-davinci-003", prompt: keyword, temperature: 0.7, max_tokens: 300)
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Secret.token)"]
        
        AF.request(baseUrl + "completions", method: .post, parameters: body, encoder: .json, headers: headers)
            .responseDecodable(of: OpenAICompletionsResponse.self) { response in
                switch response.result {
                case .success(let result):
                    completion(result.choices.first?.text ?? "error")
                case .failure(let error):
                    print(error)
                    return
                }
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
