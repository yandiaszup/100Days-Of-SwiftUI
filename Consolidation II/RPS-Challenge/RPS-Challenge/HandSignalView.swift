//
//  HandSignalView.swift
//  RPS-Challenge
//
//  Created by Yan Lucas on 17/08/20.
//  Copyright © 2020 Yan Dias. All rights reserved.
//

import SwiftUI

struct HandSignalView: View {
    
    enum HandSignal: String {
        case Scissors = "✌️"
        case Rock = "✊"
        case Paper = "🖐"
        
        func signalToWin() -> HandSignal {
            switch self {
            case .Scissors:
                return .Rock
            case .Rock:
                return .Paper
            case .Paper:
                return .Scissors
            }
        }
        
        func signalToLose() -> HandSignal {
            switch self {
            case .Scissors:
                return .Paper
            case .Rock:
                return .Scissors
            case .Paper:
                return .Rock
            }
        }
    }
    
    let signal: HandSignal
    
    var body: some View {
        Text(signal.rawValue)
            .font(.system(size: 100))
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct HandSignalView_Previews: PreviewProvider {
    static var previews: some View {
        HandSignalView(signal: .Paper)
    }
}
