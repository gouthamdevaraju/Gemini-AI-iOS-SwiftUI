//
//  ContentView.swift
//  Gemini-AI-iOS-SwiftUI
//
//  Created by Goutham Devaraju on 16/09/24.
//

import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.myKey)
    
    @State var userPrompt = ""
    @State var isLoading = false
    @State var response: LocalizedStringKey = "How can I help you today?"

    
    var body: some View {
        VStack {
            Text("Welcome to Gemini AI")
                .font(.largeTitle)
                .foregroundStyle(.indigo)
                .fontWeight(.bold)
                .padding(.top, 40)
            ZStack{
                ScrollView{
                    Text(response)
                        .font(.title)
                }
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                        .scaleEffect(4)
                }
            }
                    
            TextField("Ask anything...", text: $userPrompt, axis: .vertical)
                .lineLimit(5)
                .font(.title3)
                .padding()
                .background(Color.indigo.opacity(0.2), in: Capsule())
                .disableAutocorrection(true)
                .onSubmit {
                        generateResponse()
                }
        }
        .padding()
    }
    
    func generateResponse(){
        isLoading = true;
        response = ""
        
        Task {
            do {
                let result = try await model.generateContent(userPrompt)
                isLoading = false
                response = LocalizedStringKey(result.text ?? "No response found")
                userPrompt = ""
            } catch {
                response = "Something went wrong! \n\(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    ContentView()
}
