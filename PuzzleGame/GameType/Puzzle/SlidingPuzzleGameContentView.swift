//
//  SlidingPuzzleGameContentView.swift
//  PuzzleGame
//
//  Created by Phearunmony Chheng on 22/7/25.
//

import SwiftUI

struct SlidingPuzzleGame: View {
    @StateObject private var gameState = GameState()
    @State private var draggedTile: DraggedTileInfo?
    @State private var previewPosition: (row: Int, col: Int)?

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Sliding Puzzle")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Moves: \(gameState.moveCount)")
                    .font(.title2)

                if gameState.isGameWon {
                    Text("🎉 You Won! 🎉")
                        .font(.title)
                        .foregroundColor(.green)
                        .fontWeight(.bold)
                }

                // Game Board
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 4), spacing: 4) {
                    ForEach(0..<16, id: \.self) { index in
                        let row = index / 4
                        let col = index % 4
                        let tileValue = gameState.board[row][col]
                        let showPreview = previewPosition?.row == row && previewPosition?.col == col

                        EnhancedTileView(
                            value: tileValue,
                            row: row,
                            col: col,
                            draggedTile: $draggedTile,
                            previewPosition: $previewPosition,
                            showPreview: showPreview,
                            gameState: gameState
                        ) {
                            gameState.moveTile(row: row, col: col)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)

                Button("New Game") {
                    gameState.newGame()
                    previewPosition = nil
                }
                .font(.title2)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Spacer()
            }
            .padding()

            // Floating dragged tile
            if let draggedTile = draggedTile {
                FloatingTileView(value: draggedTile.value, position: draggedTile.position)
            }
        }
    }
}

struct DraggedTileInfo {
    let value: Int
    let position: CGPoint
    let sourceRow: Int
    let sourceCol: Int
}

struct FloatingTileView: View {
    let value: Int
    let position: CGPoint
    @State private var glitchOffset = CGSize.zero
    @State private var isGlitching = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.9))
                .frame(width: 70, height: 70)
                .shadow(radius: 8)

            Text("\(value)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .position(x: position.x, y: position.y - 40) // Position above finger
        .offset(glitchOffset)
        .scaleEffect(1.1)
        .animation(.easeOut(duration: 0.1), value: position)
        .onAppear {
            startGlitchEffect()
        }
    }

    private func startGlitchEffect() {
        isGlitching = true

        // Quick glitch animation sequence
        withAnimation(.easeInOut(duration: 0.05)) {
            glitchOffset = CGSize(width: Double.random(in: -3...3), height: Double.random(in: -3...3))
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            withAnimation(.easeInOut(duration: 0.05)) {
                glitchOffset = CGSize(width: Double.random(in: -2...2), height: Double.random(in: -2...2))
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.05)) {
                glitchOffset = CGSize(width: Double.random(in: -1...1), height: Double.random(in: -1...1))
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                glitchOffset = .zero
                isGlitching = false
            }
        }
    }
}

struct EnhancedTileView: View {
    let value: Int
    let row: Int
    let col: Int
    @Binding var draggedTile: DraggedTileInfo?
    @Binding var previewPosition: (row: Int, col: Int)?
    let showPreview: Bool
    let gameState: GameState
    let onTap: () -> Void
    @State private var isDragging = false
    @State private var dragStarted = false
    @State private var clickEffect = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Main tile
                RoundedRectangle(cornerRadius: 8)
                    .fill(getTileColor())
                    .frame(width: 70, height: 70)
                    .scaleEffect(clickEffect ? 0.95 : 1.0)

                // Preview tile (blurred)
                if showPreview, let draggedValue = draggedTile?.value {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.green.opacity(0.6))
                            .frame(width: 70, height: 70)

                        Text("\(draggedValue)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .blur(radius: 2)
                    }
                    .opacity(0.8)
                    .animation(.easeInOut(duration: 0.2), value: showPreview)
                }

                // Main tile text
                if value != 0 && !isDragging && !showPreview {
                    Text("\(value)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .scaleEffect(isDragging ? 0.8 : 1.0)
            .opacity(isDragging ? 0.3 : 1.0)
            .onDrop(of: [.text], isTargeted: nil) { providers, location in
                return false // Handle drop in gesture
            }
            .gesture(
                value == 0 ? nil : DragGesture(coordinateSpace: .global)
                    .onChanged { gesture in
                        if !isDragging {
                            isDragging = true
                            dragStarted = true

                            // Click effect
                            withAnimation(.easeInOut(duration: 0.1)) {
                                clickEffect = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.easeOut(duration: 0.1)) {
                                    clickEffect = false
                                }
                            }
                        }

                        draggedTile = DraggedTileInfo(
                            value: value,
                            position: gesture.location,
                            sourceRow: row,
                            sourceCol: col
                        )
                        updatePreviewPosition(at: gesture.location, in: geometry)
                    }
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            isDragging = false
                            dragStarted = false
                            draggedTile = nil
                            previewPosition = nil
                        }
                        onTap()
                    }
            )
            .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isDragging)
            .animation(.easeInOut(duration: 0.1), value: clickEffect)
            .disabled(value == 0)
        }
        .frame(width: 70, height: 70)
    }

    private func getTileColor() -> Color {
        if value == 0 {
            return Color.clear
        } else if isDragging {
            return Color.blue.opacity(0.3)
        } else if showPreview {
            return Color.clear
        } else {
            return Color.blue.opacity(0.8)
        }
    }

    private func updatePreviewPosition(at location: CGPoint, in geometry: GeometryProxy) {
        // Convert global position to grid position
        let emptyPos = gameState.findEmptyTile()

        // Check if dragging over the empty tile position
        let tileSize: CGFloat = 74 // 70 + 4 spacing
        let gridStartX = geometry.frame(in: .global).minX - (tileSize * CGFloat(col))
        let gridStartY = geometry.frame(in: .global).minY - (tileSize * CGFloat(row))

        let gridCol = Int((location.x - gridStartX) / tileSize)
        let gridRow = Int((location.y - gridStartY) / tileSize)

        // Only show preview if hovering over empty tile and it's a valid move
        if gridRow == emptyPos.row && gridCol == emptyPos.col &&
           gridRow >= 0 && gridRow < 4 && gridCol >= 0 && gridCol < 4 {

            let isValidMove = (abs(row - emptyPos.row) == 1 && col == emptyPos.col) ||
                             (abs(col - emptyPos.col) == 1 && row == emptyPos.row)

            if isValidMove {
                previewPosition = (row: gridRow, col: gridCol)
            } else {
                previewPosition = nil
            }
        } else {
            previewPosition = nil
        }
    }
}

struct TileView: View {
    let value: Int
    let onTap: () -> Void
    @State private var dragOffset = CGSize.zero
    @State private var isDragging = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(value == 0 ? Color.clear : (isDragging ? Color.blue.opacity(0.3) : Color.blue.opacity(0.8)))
                .frame(width: 70, height: 70)

            if value != 0 {
                Text("\(value)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(isDragging ? .clear : .white)
            }
        }
        .offset(dragOffset)
        .scaleEffect(isDragging ? 0.8 : 1.0)
        .opacity(isDragging ? 0.3 : 1.0)
        .gesture(
            value == 0 ? nil : DragGesture()
                .onChanged { gesture in
                    if !isDragging {
                        isDragging = true
                    }
                    dragOffset = gesture.translation
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        dragOffset = .zero
                        isDragging = false
                    }
                    onTap()
                }
        )
        .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isDragging)
        .disabled(value == 0)
    }
}

class GameState: ObservableObject {
    @Published var board: [[Int]] = []
    @Published var moveCount = 0
    @Published var isGameWon = false

    private let winningBoard = [
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 0]
    ]

    init() {
        newGame()
    }

    func newGame() {
        board = winningBoard
        moveCount = 0
        isGameWon = false
        shuffleBoard()
    }

    private func shuffleBoard() {
        // Perform random valid moves to shuffle the board
        for _ in 0..<1000 {
            let emptyPos = findEmptyTile()
            let possibleMoves = getValidMoves(emptyRow: emptyPos.row, emptyCol: emptyPos.col)

            if let randomMove = possibleMoves.randomElement() {
                swapTiles(row1: emptyPos.row, col1: emptyPos.col,
                         row2: randomMove.row, col2: randomMove.col)
            }
        }

        // Reset move count after shuffling
        moveCount = 0
    }

    func moveTile(row: Int, col: Int) {
        guard !isGameWon else { return }

        let emptyPos = findEmptyTile()

        // Check if the clicked tile is adjacent to the empty space
        let isAdjacent = (abs(row - emptyPos.row) == 1 && col == emptyPos.col) ||
                        (abs(col - emptyPos.col) == 1 && row == emptyPos.row)

        if isAdjacent {
            swapTiles(row1: row, col1: col, row2: emptyPos.row, col2: emptyPos.col)
            moveCount += 1
            checkWinCondition()
        }
    }

    private func swapTiles(row1: Int, col1: Int, row2: Int, col2: Int) {
        let temp = board[row1][col1]
        board[row1][col1] = board[row2][col2]
        board[row2][col2] = temp
    }

    func findEmptyTile() -> (row: Int, col: Int) {
        for row in 0..<4 {
            for col in 0..<4 {
                if board[row][col] == 0 {
                    return (row, col)
                }
            }
        }
        return (3, 3) // Default to bottom-right
    }

    private func getValidMoves(emptyRow: Int, emptyCol: Int) -> [(row: Int, col: Int)] {
        var moves: [(row: Int, col: Int)] = []

        let directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]

        for (dRow, dCol) in directions {
            let newRow = emptyRow + dRow
            let newCol = emptyCol + dCol

            if newRow >= 0 && newRow < 4 && newCol >= 0 && newCol < 4 {
                moves.append((newRow, newCol))
            }
        }

        return moves
    }

    private func checkWinCondition() {
        isGameWon = board == winningBoard
    }
}

#Preview {
    ContentView()
}


