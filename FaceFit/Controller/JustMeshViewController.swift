//
//  ViewController.swift
//  FaceFit
//
//  Created by Ricardo Venieris on 03/11/21.
//

import UIKit
import ARKit

class JustMeshViewController: UIViewController {
    
    @IBOutlet var arView: ARSCNView!
    var labels:[SCNNode] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device")
        }
        
        arView.delegate = self
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARFaceTrackingConfiguration()
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        arView.scene.background.contents = UIColor(named: "KeynoteBackground")

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }
}


extension JustMeshViewController: ARSCNViewDelegate {
    // Adding a Mesh Mask
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = arView.device,
              let faceAnchor = anchor as? ARFaceAnchor,
              let faceGeometry = ARSCNFaceGeometry(device: device) else { return nil }
        let node = SCNNode(geometry: faceGeometry)
        node.geometry?.firstMaterial?.fillMode = .lines
        printVertices(faceAnchor: faceAnchor, in: node)
        return node
    }
    
    // Updating the Mesh Mask
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard
            let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry
        else { return }
        faceGeometry.update(from: faceAnchor.geometry)
        printVertices(faceAnchor: faceAnchor, in: node, addLabel: false)
    }
    
    
    func printVertices(faceAnchor: ARFaceAnchor, in node: SCNNode, addLabel:Bool = true) {
        for index in 0..<faceAnchor.geometry.vertices.count{
//            guard [1076, 1096].contains(index) else {continue}
//            guard index%2 == 0 else {continue}
            if addLabel {
                let text = SCNText(string: String(index), extrusionDepth: 4)
                let material = SCNMaterial()
                material.diffuse.contents = UIColor.green
                material.specular.contents = UIColor.green
                text.materials = [material]
                
                let newNode = SCNNode()
                newNode.position =  SCNVector3Make(faceAnchor.geometry.vertices[index].x*1.0,faceAnchor.geometry.vertices[index].y*1.0,faceAnchor.geometry.vertices[index].z)
                newNode.scale = SCNVector3(x:0.0005, y:0.0005, z:0.001)
                newNode.geometry = text
                node.addChildNode(newNode)
                labels.append(newNode)
            } else {
                let position = SCNVector3Make(faceAnchor.geometry.vertices[index].x*1.0,faceAnchor.geometry.vertices[index].y*1.0,faceAnchor.geometry.vertices[index].z)
                labels[index].position = position
//                print()
            }
        }
    }
}
