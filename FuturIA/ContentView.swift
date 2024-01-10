//
//  ContentView.swift
//  FuturIA
//
//  Created by Anthony Chahat on 10.01.2024.
//

import SwiftUI

enum Sentiment: String {
    case positive = "POSITIVE"
    case negative = "NEGATIVE"
    case mixed = "MIXED"
    case neutral = "NEUTRAL"
    func getColor() -> Color {
        switch(self){
        case .positive:
            return Color.green
        case .negative:
            return Color.red
        case .mixed:
            return Color.purple
        case .neutral:
            return Color.gray
        }
    }
    func getEmoji() -> String {
        switch(self){
        case .positive:
            return "😄"
        case .negative:
            return "😡"
        case .mixed:
            return "🤔"
        case .neutral:
            return "😑"
        }
    }
}

struct ContentView: View {
    @State var modelInput = ""
    @State var outputSentiment: Sentiment? = nil
    
    func classify() {
        do {
            // MyModel est une classe générée automatiquement par Xcode
            let model = try IASwift(configuration: .init())
            let prediction = try model.prediction(text: modelInput)
            switch(prediction.label) {
                case "POSITIVE":
                outputSentiment = Sentiment.positive
                break
            case "NEGATIVE":
                outputSentiment = Sentiment.negative
                break
            case "MIXED":
                outputSentiment = Sentiment.mixed
                break
            case "NEUTRAL":
                outputSentiment = Sentiment.neutral
                break
            default:
                outputSentiment = Sentiment.neutral
            }
        } catch {
            outputSentiment = Sentiment.neutral
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Entrez une phrase, l'IA va deviner votre sentiment").foregroundColor(.white).fontWeight(.bold).fontDesign(.rounded)
                    TextEditor(text: $modelInput).onChange(of: modelInput, {
                        oldValue, newValue in
                        outputSentiment = nil
                    }).frame(height: 100).clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    Button(action: {
                        classify()
                    }, label: {
                        Text("Deviner le sentiment")
                    })
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .buttonStyle(BorderedProminentButtonStyle())
                        
                        .disabled(modelInput.isEmpty)
                }
                .padding()
                .background(Color.purple.gradient.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                
                VStack {
                    Text(outputSentiment?.getEmoji() ?? "")
                    Text(outputSentiment?.rawValue ?? "")
                }.frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(outputSentiment?.getColor().gradient ?? Color.blue.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .opacity(outputSentiment == nil ? 0 : 1.0)
                    .scaleEffect(outputSentiment == nil ? 0.3 : 1.0)
                    .animation(.bouncy, value: outputSentiment)
                Spacer()
            }
            .navigationTitle("🧠 IA du futur")
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

#Preview {
    ContentView(outputSentiment: Sentiment.neutral)
}
