//
//  Obstacle.swift
//  PuzzleGame
//
//  Created by Phearunmony Chheng on 22/7/25.
//

import SwiftUI

struct Obstacle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let type: ObstacleType
    
    enum ObstacleType: CaseIterable {
        case car, truck, cone
    }
}

struct TruckObstacle: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.orange)
                .frame(width: 70, height: 120)
            
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.black.opacity(0.7))
                .frame(width: 50, height: 15)
                .offset(y: -20)
        }
        .shadow(radius: 3)
    }
}

struct ConeObstacle: View {
    var body: some View {
        ZStack {
            // Cone shape
            Path { path in
                path.move(to: CGPoint(x: 0, y: -15))
                path.addLine(to: CGPoint(x: -12, y: 15))
                path.addLine(to: CGPoint(x: 12, y: 15))
                path.closeSubpath()
            }
            .fill(Color.orange)
            
            // Stripes
            Rectangle()
                .fill(Color.white)
                .frame(width: 20, height: 3)
                .offset(y: -5)
            
            Rectangle()
                .fill(Color.white)
                .frame(width: 16, height: 3)
                .offset(y: 2)
        }
        .frame(width: 24, height: 30)
        .shadow(radius: 2)
    }
}
