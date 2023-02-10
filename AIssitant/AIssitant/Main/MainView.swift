import OpenAISwift
import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        NavigationStack {
                VStack(alignment: .leading) {
                    ScrollView {
                        LazyVStack(alignment: .center) {
                            ForEach($viewModel.AIresponses, id: \.self) { string in
                                Text(string.wrappedValue)
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(20)
                                    .foregroundColor(viewModel.loadingState == .success
                                                     ? .black : .red)
                            }
                            ProgressView()
                                .opacity(viewModel.isLoading ? 1 : 0)
                                .scaleEffect(x: 2, y: 2, anchor: .center)
                                .padding(.top, 10)
                        }
                    }
                    Spacer()
                    HStack {
                        textField
                        sendButton
                        resumeButton
                    }
                    .padding(.bottom, 16)
                }
                .navigationBarTitle("ChatAI")
                .padding(.horizontal)
        }
    }
}

extension MainView {
    var resumeButton: some View {
        Button {
            viewModel.toggleSpeaking.toggle()
        } label: {
            Image(systemName: viewModel.toggleSpeaking
                  ? "stop.circle.fill"
                  : "speaker.wave.2.circle.fill")
            .resizable()
            .frame(width: 35, height: 35)
        }
    }
    
    var textField: some View {
        TextField("Type something for GPT", text: $viewModel.text)
            .padding(10)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .lineLimit(nil)
    }
    
    var sendButton: some View {
        Button(action: {
            viewModel.sendText()
        },
               label: {
            Image(systemName: "paperplane.circle.fill")
                .resizable()
                .font(.system(size: 36))
                .frame(width: 35, height: 35)
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
