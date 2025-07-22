//
//  CubeViewModel.swift
//  PuzzleGame
//
//  Created by Phearunmony Chheng on 22/7/25.
//

import Foundation
import SceneKit
import Combine

class CubeViewModel: ObservableObject {
    @Published var isSpinning = true
    
    let cubeModel = CubeModel()
    
    func toggleSpin() {
        isSpinning.toggle()
    }
}
