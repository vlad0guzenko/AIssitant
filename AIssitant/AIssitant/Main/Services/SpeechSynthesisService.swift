import AVFoundation
import Foundation

protocol SpeechSynthesisService {
    func readText(_ text: String)
    func toggleSpeaking()
}

class SpeechSynthesisServiceImplementation: SpeechSynthesisService {
    private let synthesizer: AVSpeechSynthesizer
    private let voice: AVSpeechSynthesisVoice
    
    private var text: String = ""
    
    init(synthesizer: AVSpeechSynthesizer = .init(),
         voice: AVSpeechSynthesisVoice = .init(identifier: "en-US") ?? .init()) {
        self.synthesizer = synthesizer
        self.voice = voice
    }
    
    func readText(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        utterance.volume = 1
        
        self.text = text
        
        synthesizer.speak(utterance)
    }
    
    func toggleSpeaking() {
        if synthesizer.isSpeaking {
            if synthesizer.isPaused {
                synthesizer.continueSpeaking()
            } else {
                synthesizer.pauseSpeaking(at: AVSpeechBoundary.immediate)
            }
        }
    }
}
