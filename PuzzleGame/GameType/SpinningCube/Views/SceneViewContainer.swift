//
//  SceneViewContainer.swift
//  PuzzleGame
//
//  Created by Phearunmony Chheng on 22/7/25.
//

import SwiftUI
import SceneKit

struct SceneViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: CubeViewModel

    class Coordinator {
        var cubeNode: SCNNode?
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        let scene = SCNScene()

        // Create cube
        let cube = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.05)
        let cubeNode = SCNNode(geometry: cube)
        cube.firstMaterial?.diffuse.contents = viewModel.cubeModel.color
        cube.firstMaterial?.lightingModel = .blinn
        scene.rootNode.addChildNode(cubeNode)
        context.coordinator.cubeNode = cubeNode

        // Camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 5)
        scene.rootNode.addChildNode(cameraNode)

        // Lights
        let omniLight = SCNNode()
        omniLight.light = SCNLight()
        omniLight.light?.type = .omni
        omniLight.position = SCNVector3(0, 10, 10)
        scene.rootNode.addChildNode(omniLight)

        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLight)

        scnView.scene = scene
        scnView.backgroundColor = .black
        scnView.allowsCameraControl = true

        // Start spin if needed
        if viewModel.isSpinning {
            startSpin(on: cubeNode)
        }

        return scnView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        guard let cubeNode = context.coordinator.cubeNode else { return }

        if viewModel.isSpinning {
            if cubeNode.action(forKey: "spin") == nil {
                startSpin(on: cubeNode)
            }
        } else {
            cubeNode.removeAction(forKey: "spin") // stops at current rotation
        }
    }

    private func startSpin(on node: SCNNode) {
        let spin = SCNAction.repeatForever(
            SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 5)
        )
        node.runAction(spin, forKey: "spin")
    }
}
