//
//  ObstacleView.swift
//  PuzzleGame
//
//  Created by Phearunmony Chheng on 22/7/25.
//

import SwiftUI

struct ObstacleView: View {
    let obstacle: Obstacle
    
    var body: some View {
        Group {
            switch obstacle.type {
            case .car:
                CarObstacle()
            case .truck:
                TruckObstacle()
            case .cone:
                ConeObstacle()
            }
        }
        .position(obstacle.position)
    }
}

struct CarObstacle: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.yellow)
                .frame(width: 55, height: 90)
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.black.opacity(0.7))
                .frame(width: 35, height: 20)
                .offset(y: -10)
        }
        .shadow(radius: 3)
    }
}
