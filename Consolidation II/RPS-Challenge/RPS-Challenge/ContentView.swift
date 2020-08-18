//
//  ContentView.swift
//  RPS-Challenge
//
//  Created by Yan Lucas on 17/08/20.
//  Copyright © 2020 Yan Dias. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    
    //MARK: - Properties
    
    @State private var challengeHandSignalIndex: Int = 0
    @State private var shouldWin = true
    
    @State private var score = 0
    @State private var turns = 1
    
    @State private var showTurnAlert = false
    @State private var showEndGameAlert = false
    @State private var wonTurn = false
    
    var correctAnswer: HandSignalView.HandSignal {
        let signal = handSignals[challengeHandSignalIndex]
        return shouldWin ? signal.signalToWin() : signal.signalToLose()
    }
    
    private var handSignals: [HandSignalView.HandSignal] = [.Rock, .Paper, .Scissors]
    
    //MARK: - Functions
    
    private func selectedHandSignal(at index: Int) {
        let selectedSignal = handSignals[index]
        if selectedSignal == correctAnswer {
            score += 1
            wonTurn = true
        } else {
            wonTurn = false
        }
        nextTurn()
    }
    
    private func nextTurn() {
        turns += 1
        
        if turns <= 10 {
            showTurnAlert = true
        } else {
            showEndGameAlert = true
        }
    }
    
    private func resetTurn() {
        shouldWin = Bool.random()
        challengeHandSignalIndex = Int.random(in: 0...2)
    }
    
    private func resetGame() {
        turns = 1
        score = 0
        resetTurn()
    }
    
    //MARK: UI
    
    var body: some View {
        NavigationView {
            VStack {
                HandSignalView(signal: handSignals[challengeHandSignalIndex])
                
                Text("\(shouldWin ? "To Win" : "To Lose")")
                    .modifier(BlueLargeTitle())
                
                HStack {
                    ForEach(0 ..< 3) { index in
                        Button(action: {
                            self.selectedHandSignal(at: index)
                        }) {
                            HandSignalView(signal: self.handSignals[index])
                        }
                    }
                }
                
                Text("Points: \(score)")
                    .modifier(BlueLargeTitle())
                    .alert(isPresented: $showEndGameAlert) {
                        buildEndGameAlert()
                }
                
                Text("Turn: \(turns)")
                    .modifier(BlueLargeTitle())
                    .alert(isPresented: $showTurnAlert) {
                        buildTurnAlert()
                }
            }
            .navigationBarTitle("RPS Challenge")
        }
    }
    
    private func buildEndGameAlert() -> Alert {
        Alert(
            title: Text("Finish"),
            message: Text("Your score is \(score)"),
            dismissButton: .default(Text("Try again"), action: {
                self.resetGame()
            })
        )
    }
    
    private func buildTurnAlert() -> Alert {
        Alert(
            title: Text("\(wonTurn ? "Correct!" : "Wrong")"),
            message: Text("hello"),
            dismissButton: .default(Text("Continue"), action: {
                self.resetTurn()
            })
        )
    }
}

struct BlueLargeTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.all, 20)
            .font(.title)
            .foregroundColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
