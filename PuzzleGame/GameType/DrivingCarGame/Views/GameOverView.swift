//
//  GameOverView.swift
//  PuzzleGame
//
//  Created by Phearunmony Chheng on 22/7/25.
//

import SwiftUI

struct GameOverView: View {
    let score: Int
    let onRestart: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black.opacity(0.8))
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("GAME OVER")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                
                Text("Final Score: \(score)")
                    .font(.title)
                    .foregroundColor(.white)
                
                Button("RESTART") {
                    onRestart()
                }
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
}
