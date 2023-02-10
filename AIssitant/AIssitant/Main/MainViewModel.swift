import Combine
import AVFAudio
import OpenAISwift
import Dispatch

extension MainView {
    @MainActor final class MainViewModel: ObservableObject {
        @Published private(set) var loadingState: LoadingState = .success
        @Published var AIresponses: [String] = []
        @Published var text: String = ""
        @Published var isLoading: Bool = false
        @Published var toggleSpeaking: Bool = true
        
        private var cancellable: AnyCancellable?
        
        private let openAIService: OpenAIService
        private let speechSynthesisService: SpeechSynthesisService
        
        init(openAIService: OpenAIService = OpenAIServiceImplementation(token: "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"),
             speechSynthesisService: SpeechSynthesisService = SpeechSynthesisServiceImplementation()) {
            self.openAIService = openAIService
            self.speechSynthesisService = speechSynthesisService
            
            bindChatGPTSpeaking()
        }
        
        func bindChatGPTSpeaking() {
            cancellable = $toggleSpeaking.sink { [weak self] _ in
                self?.speechSynthesisService.toggleSpeaking()
            }
        }
        
        func sendText() {
            guard text != "" else {
                return
            }
            
            isLoading = true
            
            openAIService.sendMessageToAi(text) { [weak self] response, state in
                switch state {
                case .success:
                    DispatchQueue.main.async {
                        self?.AIresponses.append("ChatGPT:" + response)
                        self?.text = ""
                        self?.speechSynthesisService.readText(response)
                    }
                case .error:
                    self?.AIresponses.append("ChatGPT: oh, sorry, something went wrong - " + response)
                }
                
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            }
        }
        
        
    }
}
