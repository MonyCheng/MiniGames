//
//  DrivingCarGame.swift
//  PuzzleGame
//
//  Created by Phearunmony Chheng on 22/7/25.
//

import SwiftUI

struct DrivingCarGame: View {
    @StateObject private var gameState = CarGameState()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Road background
                RoadBackground()
                
                // Road lanes
                RoadLanes(offset: gameState.laneOffset)
                
                // Obstacles
                ForEach(gameState.obstacles) { obstacle in
                    ObstacleView(obstacle: obstacle)
                }
                
                // Player car
                PlayerCar(position: gameState.carPosition)
                
                // Game over overlay
                if gameState.gameOver {
                    GameOverView(score: gameState.score) {
                        gameState.restartGame()
                    }
                }
                
                // UI Overlay
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Score: \(gameState.score)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Speed: \(Int(gameState.speed))")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text("Time: \(gameState.gameTime)s")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        if !gameState.gameStarted {
                            Spacer()
                            Button("START") {
                                gameState.startGame()
                            }
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.top, 100)
                    .padding([.leading, .trailing], 18)
                    Spacer()
                    
                    // Controls
                    if gameState.gameStarted && !gameState.gameOver {
                        HStack(spacing: 140) {
                            Button("⬅️") {
                                gameState.moveLeft()
                            }
                            .font(.system(size: 40))
                            .frame(width: 80, height: 80)
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(40)
                            
                            Button("➡️") {
                                gameState.moveRight()
                            }
                            .font(.system(size: 40))
                            .frame(width: 80, height: 80)
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(40)
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
            .background(Color.green.opacity(0.3))
            .onAppear {
                gameState.screenSize = geometry.size
                gameState.carPosition = CGPoint(x: geometry.size.width / 2,
                                                y: geometry.size.height * 0.7)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        if gameState.gameStarted && !gameState.gameOver {
                            gameState.handleDrag(location: gesture.location.x)
                        }
                    }
            )
        }
        .ignoresSafeArea()
    }
}
