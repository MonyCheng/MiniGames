//
//  SpinningContentView.swift
//  PuzzleGame
//
//  Created by Phearunmony Chheng on 22/7/25.
//

import SwiftUI

struct SpinningContentView: View {
    @StateObject private var viewModel = CubeViewModel()

     var body: some View {
         VStack {
             SceneViewContainer(viewModel: viewModel)

             Toggle("Spin Cube", isOn: $viewModel.isSpinning)
                 .padding()
                 .foregroundColor(.white)
         }
         .background(Color.black.edgesIgnoringSafeArea(.all))
     }
}

#Preview {
//    ContentView()
}
