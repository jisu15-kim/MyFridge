//
//  AIManager.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/02.
//

import Foundation
import Alamofire

class AIManager {
    let maxToken = 100
    let davinci = "text-davinci-003"
    let chatAI = "gpt-3.5-turbo"
    
    func askRecommandStoreWay(keyword: String, completion: @escaping (String) -> Void) {
        let baseUrl = Secret.baseUrl
        let body = OpenAICompletionsBody(model: davinci, prompt: keyword, temperature: 0.7, max_tokens: maxToken)
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Secret.token)"]
        
        AF.request(baseUrl + "chat/completions", method: .post, parameters: body, encoder: .json, headers: headers)
            .responseData(completionHandler: { data in
                switch data.result {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error)
                }
            })
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
    
    func askChatAIApi(keyword: String, completion: @escaping (String) -> Void) {
        let baseUrl = Secret.baseUrl + "chat/completions"
        let message = Message(role: "user", content: keyword)
        
        let body = ChatAIPostBody(model: "gpt-3.5-turbo", messages: [message], max_tokens: maxToken)
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Secret.token)", "content-Type": "application/json"]
        AF.request(baseUrl, method: .post, parameters: body, encoder: .json, headers: headers)
            .responseDecodable(of: OpenAIChatResponse.self) { response in
                switch response.result {
                case .success(let result):
                    let message = result.choices.first?.message.content ?? "error"
//                    print("DEBUG - 사용된 토큰: \(result.usage.totalTokens)")
                    print(message)
                    completion(message)
                case .failure(let error):
                    print(error)
                    return
                }
            }
    }
}


struct ChatAIPostBody: Codable {
    let model: String
    let messages: [Message]
    let max_tokens: Int
}

struct ChatAIPostBodyMessage: Codable {
    let role: String
    let content: String
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
