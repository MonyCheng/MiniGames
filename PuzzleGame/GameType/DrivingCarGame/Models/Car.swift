//
//  Car.swift
//  PuzzleGame
//
//  Created by Phearunmony Chheng on 22/7/25.
//

import SwiftUI

struct PlayerCar: View {
    let position: CGPoint

    var body: some View {
        ZStack {
            // Car body
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.red)
                .frame(width: 60, height: 100)

            // Car details
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.7))
                .frame(width: 40, height: 25)
                .offset(y: -15)

            // Wheels
            Circle()
                .fill(Color.black)
                .frame(width: 12, height: 12)
                .offset(x: -20, y: -30)

            Circle()
                .fill(Color.black)
                .frame(width: 12, height: 12)
                .offset(x: 20, y: -30)

            Circle()
                .fill(Color.black)
                .frame(width: 12, height: 12)
                .offset(x: -20, y: 30)

            Circle()
                .fill(Color.black)
                .frame(width: 12, height: 12)
                .offset(x: 20, y: 30)
        }
        .position(position)
        .shadow(radius: 5)
    }
}

//struct PlayerCar: View {
//    let position: CGPoint
//
//    var body: some View {
//        Image("car") // Make sure this matches the name in Assets
//            .resizable()
//            .frame(width: 60, height: 100)
//            .position(position)
//            .shadow(radius: 5)
//    }
//}
