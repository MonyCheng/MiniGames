//
//  CarDrivingContentView.swift
//  PuzzleGame
//
//  Created by Phearunmony Chheng on 22/7/25.
//

import SwiftUI

struct CarDrivingContentView: View {
    var body: some View {
        DrivingCarGame()
    }
}

struct CarDrivingContentView_Previews: PreviewProvider {
    static var previews: some View {
        CarDrivingContentView()
    }
}


//struct DrivingCarGame: View {
//    @StateObject private var gameState = CarGameState()
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                // Road background
//                RoadBackground()
//                
//                // Road lanes
//                RoadLanes(offset: gameState.laneOffset)
//                
//                // Obstacles
//                ForEach(gameState.obstacles) { obstacle in
//                    ObstacleView(obstacle: obstacle)
//                }
//                
//                // Player car
//                PlayerCar(position: gameState.carPosition)
//                
//                // Game over overlay
//                if gameState.gameOver {
//                    GameOverView(score: gameState.score) {
//                        gameState.restartGame()
//                    }
//                }
//                
//                // UI Overlay
//                VStack {
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text("Score: \(gameState.score)")
//                                .font(.title2)
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//                            
//                            Text("Speed: \(Int(gameState.speed))")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                            
//                            Text("Time: \(gameState.gameTime)s")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                        }
//                        
//                        Spacer()
//                        
//                        if !gameState.gameStarted {
//                            Spacer()
//                            Button("START") {
//                                gameState.startGame()
//                            }
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .padding()
//                            .background(Color.green)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                        }
//                    }
//                    .padding(.top, 100)
//                    .padding([.leading, .trailing], 18)
//                    Spacer()
//                    
//                    // Controls
//                    if gameState.gameStarted && !gameState.gameOver {
//                        HStack(spacing: 140) {
//                            Button("⬅️") {
//                                gameState.moveLeft()
//                            }
//                            .font(.system(size: 40))
//                            .frame(width: 80, height: 80)
//                            .background(Color.blue.opacity(0.8))
//                            .foregroundColor(.white)
//                            .cornerRadius(40)
//                            
//                            Button("➡️") {
//                                gameState.moveRight()
//                            }
//                            .font(.system(size: 40))
//                            .frame(width: 80, height: 80)
//                            .background(Color.blue.opacity(0.8))
//                            .foregroundColor(.white)
//                            .cornerRadius(40)
//                        }
//                        .padding(.bottom, 40)
//                    }
//                }
//            }
//            .background(Color.green.opacity(0.3))
//            .onAppear {
//                gameState.screenSize = geometry.size
//                gameState.carPosition = CGPoint(x: geometry.size.width / 2,
//                                                y: geometry.size.height * 0.7)
//            }
//            .gesture(
//                DragGesture(minimumDistance: 0)
//                    .onChanged { gesture in
//                        if gameState.gameStarted && !gameState.gameOver {
//                            gameState.handleDrag(location: gesture.location.x)
//                        }
//                    }
//            )
//        }
//        .ignoresSafeArea()
//    }
//}

//struct RoadBackground: View {
//    var body: some View {
//        Rectangle()
//            .fill(Color.gray.opacity(0.8))
//            .ignoresSafeArea()
//    }
//}

//struct RoadLanes: View {
//    let offset: CGFloat
//    
//    var body: some View {
//        GeometryReader { geometry in
//            let laneWidth = geometry.size.width / 4
//            
//            // Lane dividers
//            ForEach(1..<4, id: \.self) { lane in
//                Path { path in
//                    let x = laneWidth * CGFloat(lane)
//                    let dashHeight: CGFloat = 30
//                    let dashSpacing: CGFloat = 20
//                    
//                    var y: CGFloat = -dashHeight + offset.truncatingRemainder(dividingBy: dashHeight + dashSpacing)
//                    
//                    while y < geometry.size.height + dashHeight {
//                        path.move(to: CGPoint(x: x, y: y))
//                        path.addLine(to: CGPoint(x: x, y: y + dashHeight))
//                        y += dashHeight + dashSpacing
//                    }
//                }
//                .stroke(Color.white, lineWidth: 3)
//            }
//        }
//    }
//}

//struct PlayerCar: View {
//    let position: CGPoint
//    
//    var body: some View {
//        ZStack {
//            // Car body
//            RoundedRectangle(cornerRadius: 15)
//                .fill(Color.red)
//                .frame(width: 60, height: 100)
//            
//            // Car details
//            RoundedRectangle(cornerRadius: 8)
//                .fill(Color.blue.opacity(0.7))
//                .frame(width: 40, height: 25)
//                .offset(y: -15)
//            
//            // Wheels
//            Circle()
//                .fill(Color.black)
//                .frame(width: 12, height: 12)
//                .offset(x: -20, y: -30)
//            
//            Circle()
//                .fill(Color.black)
//                .frame(width: 12, height: 12)
//                .offset(x: 20, y: -30)
//            
//            Circle()
//                .fill(Color.black)
//                .frame(width: 12, height: 12)
//                .offset(x: -20, y: 30)
//            
//            Circle()
//                .fill(Color.black)
//                .frame(width: 12, height: 12)
//                .offset(x: 20, y: 30)
//        }
//        .position(position)
//        .shadow(radius: 5)
//    }
//}
//
//struct Obstacle: Identifiable {
//    let id = UUID()
//    var position: CGPoint
//    let type: ObstacleType
//    
//    enum ObstacleType: CaseIterable {
//        case car, truck, cone
//    }
//}
//
//struct ObstacleView: View {
//    let obstacle: Obstacle
//    
//    var body: some View {
//        Group {
//            switch obstacle.type {
//            case .car:
//                CarObstacle()
//            case .truck:
//                TruckObstacle()
//            case .cone:
//                ConeObstacle()
//            }
//        }
//        .position(obstacle.position)
//    }
//}
//
//struct CarObstacle: View {
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 12)
//                .fill(Color.yellow)
//                .frame(width: 55, height: 90)
//            
//            RoundedRectangle(cornerRadius: 6)
//                .fill(Color.black.opacity(0.7))
//                .frame(width: 35, height: 20)
//                .offset(y: -10)
//        }
//        .shadow(radius: 3)
//    }
//}
//
//struct TruckObstacle: View {
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 8)
//                .fill(Color.orange)
//                .frame(width: 70, height: 120)
//            
//            RoundedRectangle(cornerRadius: 4)
//                .fill(Color.black.opacity(0.7))
//                .frame(width: 50, height: 15)
//                .offset(y: -20)
//        }
//        .shadow(radius: 3)
//    }
//}
//
//struct ConeObstacle: View {
//    var body: some View {
//        ZStack {
//            // Cone shape
//            Path { path in
//                path.move(to: CGPoint(x: 0, y: -15))
//                path.addLine(to: CGPoint(x: -12, y: 15))
//                path.addLine(to: CGPoint(x: 12, y: 15))
//                path.closeSubpath()
//            }
//            .fill(Color.orange)
//            
//            // Stripes
//            Rectangle()
//                .fill(Color.white)
//                .frame(width: 20, height: 3)
//                .offset(y: -5)
//            
//            Rectangle()
//                .fill(Color.white)
//                .frame(width: 16, height: 3)
//                .offset(y: 2)
//        }
//        .frame(width: 24, height: 30)
//        .shadow(radius: 2)
//    }
//}

//struct GameOverView: View {
//    let score: Int
//    let onRestart: () -> Void
//    
//    var body: some View {
//        ZStack {
//            Rectangle()
//                .fill(Color.black.opacity(0.8))
//                .ignoresSafeArea()
//            
//            VStack(spacing: 20) {
//                Text("GAME OVER")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(.red)
//                
//                Text("Final Score: \(score)")
//                    .font(.title)
//                    .foregroundColor(.white)
//                
//                Button("RESTART") {
//                    onRestart()
//                }
//                .font(.title2)
//                .fontWeight(.bold)
//                .padding()
//                .background(Color.green)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//            }
//        }
//    }
//}

//class CarGameState: ObservableObject {
//    @Published var carPosition = CGPoint(x: 200, y: 600)
//    @Published var obstacles: [Obstacle] = []
//    @Published var score = 0
//    @Published var speed: Double = 5.0
//    @Published var gameOver = false
//    @Published var gameStarted = false
//    @Published var laneOffset: CGFloat = 0
//    @Published var gameTime: Int = 0 // Track game time in seconds
//    
//    var screenSize = CGSize.zero
//    private var gameTimer: Timer?
//    private var obstacleTimer: Timer?
//    private var durationTimer: Timer? // Timer for tracking game duration
//    private let carWidth: CGFloat = 60
//    private let carHeight: CGFloat = 100
//    
//    // Speed progression settings
//    private let baseSpeed: Double = 5.0
//    private let maxSpeed: Double = 20.0
//    private let speedIncreaseInterval: TimeInterval = 10.0 // Increase speed every 10 seconds
//    private let speedIncreaseAmount: Double = 2.0 // Increase by 2.0 each interval
//    
//    // Smooth drag properties
//    private var targetX: CGFloat = 0
//    private let smoothingFactor: CGFloat = 0.15
//    
//    func startGame() {
//        gameStarted = true
//        gameOver = false
//        score = 0
//        speed = baseSpeed
//        gameTime = 0
//        obstacles.removeAll()
//        
//        if screenSize != .zero {
//            carPosition = CGPoint(x: screenSize.width / 2, y: screenSize.height - 150)
////            carPosition = CGPoint(x: screenSize.width / 2, y: screenSize.height * 0.75)
//            targetX = carPosition.x
//        }
//        
//        startGameLoop()
//        startObstacleSpawning()
//        startDurationTimer()
//    }
//    
//    func restartGame() {
//        stopGame()
//        startGame()
//    }
//    
//    private func startGameLoop() {
//        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
//            self.updateGame()
//        }
//    }
//    
//    private func startObstacleSpawning() {
//        obstacleTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
//            self.spawnObstacle()
//        }
//    }
//    
//    private func startDurationTimer() {
//        durationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//            self.gameTime += 1
//            self.updateSpeedByDuration()
//        }
//    }
//    
//    private func updateSpeedByDuration() {
//        // Calculate speed based on duration (every 10 seconds, increase speed)
//        let speedLevel = Double(gameTime) / speedIncreaseInterval
//        let targetSpeed = baseSpeed + (speedLevel * speedIncreaseAmount)
//        speed = min(targetSpeed, maxSpeed) // Cap at maximum speed
//    }
//    
//    private func updateGame() {
//        // Smooth car movement
//        let deltaX = targetX - carPosition.x
//        if abs(deltaX) > 0.5 {
//            carPosition.x += deltaX * smoothingFactor
//        }
//        
//        // Move obstacles down
//        obstacles = obstacles.compactMap { obstacle in
//            var updatedObstacle = obstacle
//            updatedObstacle.position.y += speed
//            
//            // Remove obstacles that are off screen
//            if updatedObstacle.position.y > screenSize.height + 50 {
//                DispatchQueue.main.async {
//                    self.score += 10
//                }
//                return nil
//            }
//            
//            return updatedObstacle
//        }
//        
//        // Update lane animation
//        laneOffset += speed
//        
//        // Check collisions
//        checkCollisions()
//        
//        // Note: Removed the old gradual speed increase since we now use duration-based increases
//    }
//    
//    private func spawnObstacle() {
//        guard screenSize != .zero else { return }
//        
//        let laneWidth = screenSize.width / 4
//        let lane = Int.random(in: 0..<4)
//        let x = laneWidth * CGFloat(lane) + laneWidth / 2
//        
//        let obstacle = Obstacle(
//            position: CGPoint(x: x, y: -50),
//            type: Obstacle.ObstacleType.allCases.randomElement() ?? .car
//        )
//        
//        obstacles.append(obstacle)
//    }
//    
//    private func checkCollisions() {
//        for obstacle in obstacles {
//            let distance = sqrt(pow(carPosition.x - obstacle.position.x, 2) + pow(carPosition.y - obstacle.position.y, 2))
//            
//            if distance < 50 { // Collision threshold
//                gameOver = true
//                stopGame()
//                break
//            }
//        }
//    }
//    
//    private func stopGame() {
//        gameTimer?.invalidate()
//        obstacleTimer?.invalidate()
//        durationTimer?.invalidate()
//        gameTimer = nil
//        obstacleTimer = nil
//        durationTimer = nil
//    }
//    
//    func moveLeft() {
//        let laneWidth = screenSize.width / 4
//        let newX = max(laneWidth / 2, carPosition.x - laneWidth)
//        targetX = newX
//    }
//    
//    func moveRight() {
//        let laneWidth = screenSize.width / 4
//        let newX = min(screenSize.width - laneWidth / 2, carPosition.x + laneWidth)
//        targetX = newX
//    }
//    
//    func handleDrag(location: CGFloat) {
//        // Constrain to screen bounds with proper padding
//        let padding: CGFloat = 30
//        let constrainedX = max(padding, min(screenSize.width - padding, location))
//        targetX = constrainedX
//    }
//}

#Preview {
    ContentView()
}
