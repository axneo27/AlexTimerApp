//
//  Scramble3DView.swift
//  cubeTimer
//
//  Created by Oleksii on 31.07.2025.
//
import SwiftUI
import SceneKit

struct CubeScramble3DView: UIViewRepresentable {
    @Binding var cubeVertices: [[Color?]]
    
    init(cv: Binding<[[Color?]]>) {
        self._cubeVertices = cv
    }
    
    func createGridMaterial(_ color: UIColor, _ size: Int) -> SCNMaterial {
        var sideVertex: [[UIColor]] = []
        for _ in 0..<size {
            var row: [UIColor] = []
            for _ in 0..<size {
                row.append(color)
            }
            sideVertex.append(row)
        }
        return createGridMaterial(from: sideVertex)
    }
    
    func createGridMaterial(from sideVertex: [[UIColor]] = [
        [.red, .green, .green],
        [.green, .blue, .blue],
        [.green, .green, .green],
    ]) -> SCNMaterial {
        let material = SCNMaterial()
        let borderWidth = 10.0
        let size = 256
        
        let cgsize = CGSize(width: size, height: size)
        let renderer = UIGraphicsImageRenderer(size: cgsize)
        
        let image = renderer.image { context in
            UIColor.black.setFill()
            context.fill(CGRect(origin: .zero, size: cgsize))
            
            UIColor.black.setStroke()
            for i in 0..<sideVertex.count {
                for j in 0..<sideVertex.count {
                    let rectFrame = CGRect(x: (size*j)/sideVertex.count, y: (size*i)/sideVertex.count, width: size/sideVertex.count, height: size/sideVertex.count)
                    
                    sideVertex[i][j].setFill()
                    
                    let path = UIBezierPath(roundedRect: rectFrame, byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 16.0, height: 16.0))
                    
                    path.lineWidth = borderWidth
                    path.fill()
                    path.stroke()
                }
            }
        }
        
        material.diffuse.contents = image
        
        return material
    }
    
    func getSideVertex(_ startI: Int, _ startJ: Int, _ size: Int) -> [[UIColor]] {
        var res: [[UIColor]] = []
        for i in startI..<startI+size {
            var row: [UIColor] = []
            for j in startJ..<startJ+size {
                row.append(UIColor(cubeVertices[i][j] ?? .black))
            }
            res.append(row)
        }
        return res
    }
    
    func getSidesVerticesArray() -> [[[UIColor]]] {
        var res: [[[UIColor]]] = []
        let size = Int(cubeVertices.count/3)
        res.append(getSideVertex(size, size, size))
        res.append(getSideVertex(size, size*2, size))
        res.append(getSideVertex(size, size*3, size))
        res.append(getSideVertex(size, 0, size))
        res.append(getSideVertex(0, size, size))
        res.append(getSideVertex(size*2, size, size))
        return res
        
//        cubeVertices[i + cubeWH][j] = .orange
//        cubeVertices[i][j + cubeWH] = .white
//        cubeVertices[i + cubeWH][j + cubeWH] = .green
//        cubeVertices[i + cubeWH][j + cubeWH*2] = .red
//        cubeVertices[i + cubeWH][j + cubeWH*3] = .blue
//        cubeVertices[i + cubeWH*2][j + cubeWH] = .yellow
    }
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        let scene = SCNScene()
            
        let cube = SCNNode(geometry: SCNBox(width: 0.6, height: 0.6, length: 0.6, chamferRadius: 0.025))
        
        let sideVertices = getSidesVerticesArray()
        var materials: [SCNMaterial] = []
        for i in sideVertices {
            materials.append(createGridMaterial(from: i))
        }
        cube.geometry?.materials = materials //
        
        scene.rootNode.addChildNode(cube)
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0.8, 1, 1.5)
        let lookAtConstraint = SCNLookAtConstraint(target: cube)
        cameraNode.constraints = [lookAtConstraint]
        cameraNode.camera?.focalLength = 40
        scene.rootNode.addChildNode(cameraNode)
        
//        let light = SCNLight()
//        light.type = .area
//        let lightNode = SCNNode()
//        lightNode.light = light
//        lightNode.position = SCNVector3(-1, 1,4)
//        scene.rootNode.addChildNode(lightNode)
    
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = UIColor.black
        
        sceneView.isOpaque = false
//        sceneView.backgroundColor = .clear

        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}
}

#Preview {
    @ObservedObject var scrambleMatrixGenerator: ScrambleMatrixGenerator = .init(dis: Discipline.four, sc: "R U R' U' Rw")
    CubeScramble3DView(cv: $scrambleMatrixGenerator.cubeVertices)
}
