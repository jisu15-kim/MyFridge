//
//  AIManager.swift
//  MyFridge
//
//  Created by 김지수 on 2023/03/02.
//

import Foundation
import Alamofire

class AIManager {
    
    //MARK: - API
    let maxToken: Int = 2000
    let davinci: String = "text-davinci-003"
    let chatAI: String = "gpt-3.5-turbo"
    let errorMessage: String = "데이터 통신 오류가 발생했습니다. 다시 시도해주세요🙏"
    
    func askChatAIApi(keyword: String, completion: @escaping (Bool, String) -> Void) {
        let baseUrl = Secret.baseUrl.rawValue + "chat/completions"
        let message = Message(role: "user", content: keyword)
        
        let body = ChatAIPostBody(model: "gpt-3.5-turbo", messages: [message], max_tokens: maxToken)
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Secret.token.rawValue)", "content-Type": "application/json"]
        
        AF.request(baseUrl, method: .post, parameters: body, encoder: .json, headers: headers)
            .responseDecodable(of: OpenAIChatResponse.self) { [weak self] response in
                switch response.result {
                case .success(let result):
                    var message = result.choices.first?.message.content ?? "error"
                    if message.hasPrefix("\n\n") {
                        message.removeFirst(2)
                    }
                    print(message)
                    completion(true, message)
                    ApiCallCounter.shared.decreaseAPICallCount()
                    print("오늘 남은 API 호출 횟수 \(ApiCallCounter.shared.getAPICallCount())")
                    return
                case .failure(let error):
                    print(error)
                    print(error.errorDescription as Any)
                    guard let self = self else { return }
                    completion(false, self.errorMessage)
                    return
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
}
