//
//  RoadLanes.swift
//  PuzzleGame
//
//  Created by Phearunmony Chheng on 22/7/25.
//

import SwiftUI

struct RoadLanes: View {
    let offset: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let laneWidth = geometry.size.width / 4
            
            // Lane dividers
            ForEach(1..<4, id: \.self) { lane in
                Path { path in
                    let x = laneWidth * CGFloat(lane)
                    let dashHeight: CGFloat = 30
                    let dashSpacing: CGFloat = 20
                    
                    var y: CGFloat = -dashHeight + offset.truncatingRemainder(dividingBy: dashHeight + dashSpacing)
                    
                    while y < geometry.size.height + dashHeight {
                        path.move(to: CGPoint(x: x, y: y))
                        path.addLine(to: CGPoint(x: x, y: y + dashHeight))
                        y += dashHeight + dashSpacing
                    }
                }
                .stroke(Color.white, lineWidth: 3)
            }
        }
    }
}
