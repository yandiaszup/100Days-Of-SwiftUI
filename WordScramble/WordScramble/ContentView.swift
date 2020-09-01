//
//  ContentView.swift
//  WordScramble
//
//  Created by Yan Lucas on 01/09/20.
//  Copyright © 2020 Yan Dias. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWorld = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWorld, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                
                List(usedWords, id: \.self) {
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                }
            }
            .navigationBarTitle(rootWord)
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) { () -> Alert in
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("Ok")))
            }
            .navigationBarItems(leading: Button("Start game") { self.startGame() })
            
        }
    }
    
    private func addNewWord() {
        let answer = newWorld.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0, validate(word: answer) else { return }
        
        usedWords.insert(answer, at: 0)
        newWorld = ""
    }
    
    private func validate(word: String) -> Bool {
        guard isOriginal(word: word) else {
            wordError(title: "Word used already", message: "Be more original")
            return false
        }
        
        guard isPossible(word: word) else {
            wordError(title: "Word not recognizer", message: "You cant just make them up, you know!")
            return false
        }
        
        guard isReal(word: word) else {
            wordError(title: "Word not possible", message: "That isn't a real word")
            return false
        }
        
        return true
    }
    
    private func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    private func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    private func startGame() {
        guard
            let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"),
            let startWords = try? String(contentsOf: startWordsURL)
        else {
            fatalError("Could not load start.txt from bundle.")
        }
        let allWords = startWords.components(separatedBy: "\n")
        rootWord = allWords.randomElement() ?? "silkworm"
        newWorld = ""
        usedWords = []
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
