import OpenAISwift

protocol OpenAIService {
    func sendMessageToAi(_ text: String, completion: @escaping((String, LoadingState) -> Void))
}

class OpenAIServiceImplementation: OpenAIService {
    let openAI: OpenAISwift
    
    init(token: String) {
        self.openAI = OpenAISwift(authToken: token)
    }
    
    func sendMessageToAi(_ text: String,
                         completion: @escaping ((String, LoadingState) -> Void)){
        openAI.sendCompletion(with: text, maxTokens: 500, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                completion(output, .success)
            case .failure(let error):
                let output = error.localizedDescription
                completion(output, .error)
            }
        })
    }
}
