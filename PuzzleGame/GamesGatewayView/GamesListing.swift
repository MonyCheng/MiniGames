//
//  GamesListing.swift
//  PuzzleGame
//
//  Created by Phearunmony Chheng on 22/7/25.
//

import SwiftUI

import SwiftUI

struct GamesListing: View {
    var body: some View {
        NavigationView {
            List(allGames) { game in
                NavigationLink(destination: game.destination) {
                    HStack(spacing: 16) {
                        Image(systemName: game.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .cornerRadius(12)
                            .padding(4)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(game.title)
                                .font(.headline)
                            Text("Play now")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Mini Games")
        }
    }
}

#Preview {
    GamesListing()
}

struct GameItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let destination: AnyView
}

let allGames: [GameItem] = [
    GameItem(title: "Driving Car Game", imageName: "car"        , destination: AnyView(CarDrivingContentView())),
    GameItem(title: "Sliding Puzzle"  , imageName: "list.number", destination: AnyView(SlidingPuzzleGame())),
    GameItem(title: "Spinning Cube"   , imageName: "cube"       , destination: AnyView(SpinningContentView()))
]
