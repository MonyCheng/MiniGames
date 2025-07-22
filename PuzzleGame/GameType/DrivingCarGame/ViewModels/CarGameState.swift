//
//  CarGameState.swift
//  PuzzleGame
//
//  Created by Phearunmony Chheng on 22/7/25.
//

import Foundation

class CarGameState: ObservableObject {
    @Published var carPosition = CGPoint(x: 200, y: 600)
    @Published var obstacles: [Obstacle] = []
    @Published var score = 0
    @Published var speed: Double = 5.0
    @Published var gameOver = false
    @Published var gameStarted = false
    @Published var laneOffset: CGFloat = 0
    @Published var gameTime: Int = 0 // Track game time in seconds
    
    var screenSize = CGSize.zero
    private var gameTimer: Timer?
    private var obstacleTimer: Timer?
    private var durationTimer: Timer? // Timer for tracking game duration
    private let carWidth: CGFloat = 60
    private let carHeight: CGFloat = 100
    
    // Speed progression settings
    private let baseSpeed: Double = 5.0
    private let maxSpeed: Double = 20.0
    private let speedIncreaseInterval: TimeInterval = 10.0 // Increase speed every 10 seconds
    private let speedIncreaseAmount: Double = 2.0 // Increase by 2.0 each interval
    
    // Smooth drag properties
    private var targetX: CGFloat = 0
    private let smoothingFactor: CGFloat = 0.15
    
    func startGame() {
        gameStarted = true
        gameOver = false
        score = 0
        speed = baseSpeed
        gameTime = 0
        obstacles.removeAll()
        
        if screenSize != .zero {
            carPosition = CGPoint(x: screenSize.width / 2, y: screenSize.height - 150)
//            carPosition = CGPoint(x: screenSize.width / 2, y: screenSize.height * 0.75)
            targetX = carPosition.x
        }
        
        startGameLoop()
        startObstacleSpawning()
        startDurationTimer()
    }
    
    func restartGame() {
        stopGame()
        startGame()
    }
    
    private func startGameLoop() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            self.updateGame()
        }
    }
    
    private func startObstacleSpawning() {
        obstacleTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            self.spawnObstacle()
        }
    }
    
    private func startDurationTimer() {
        durationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.gameTime += 1
            self.updateSpeedByDuration()
        }
    }
    
    private func updateSpeedByDuration() {
        // Calculate speed based on duration (every 10 seconds, increase speed)
        let speedLevel = Double(gameTime) / speedIncreaseInterval
        let targetSpeed = baseSpeed + (speedLevel * speedIncreaseAmount)
        speed = min(targetSpeed, maxSpeed) // Cap at maximum speed
    }
    
    private func updateGame() {
        // Smooth car movement
        let deltaX = targetX - carPosition.x
        if abs(deltaX) > 0.5 {
            carPosition.x += deltaX * smoothingFactor
        }
        
        // Move obstacles down
        obstacles = obstacles.compactMap { obstacle in
            var updatedObstacle = obstacle
            updatedObstacle.position.y += speed
            
            // Remove obstacles that are off screen
            if updatedObstacle.position.y > screenSize.height + 50 {
                DispatchQueue.main.async {
                    self.score += 10
                }
                return nil
            }
            
            return updatedObstacle
        }
        
        // Update lane animation
        laneOffset += speed
        
        // Check collisions
        checkCollisions()
        
        // Note: Removed the old gradual speed increase since we now use duration-based increases
    }
    
    private func spawnObstacle() {
        guard screenSize != .zero else { return }
        
        let laneWidth = screenSize.width / 4
        let lane = Int.random(in: 0..<4)
        let x = laneWidth * CGFloat(lane) + laneWidth / 2
        
        let obstacle = Obstacle(
            position: CGPoint(x: x, y: -50),
            type: Obstacle.ObstacleType.allCases.randomElement() ?? .car
        )
        
        obstacles.append(obstacle)
    }
    
    private func checkCollisions() {
        for obstacle in obstacles {
            let distance = sqrt(pow(carPosition.x - obstacle.position.x, 2) + pow(carPosition.y - obstacle.position.y, 2))
            
            if distance < 50 { // Collision threshold
                gameOver = true
                stopGame()
                break
            }
        }
    }
    
    private func stopGame() {
        gameTimer?.invalidate()
        obstacleTimer?.invalidate()
        durationTimer?.invalidate()
        gameTimer = nil
        obstacleTimer = nil
        durationTimer = nil
    }
    
    func moveLeft() {
        let laneWidth = screenSize.width / 4
        let newX = max(laneWidth / 2, carPosition.x - laneWidth)
        targetX = newX
    }
    
    func moveRight() {
        let laneWidth = screenSize.width / 4
        let newX = min(screenSize.width - laneWidth / 2, carPosition.x + laneWidth)
        targetX = newX
    }
    
    func handleDrag(location: CGFloat) {
        // Constrain to screen bounds with proper padding
        let padding: CGFloat = 30
        let constrainedX = max(padding, min(screenSize.width - padding, location))
        targetX = constrainedX
    }
}
