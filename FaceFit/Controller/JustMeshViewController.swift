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
    var labels:[Int:SCNNode] = [:]
    var scale: CGFloat = 1
    var initialScale: CGFloat = 1
    var faceNode = SCNNode()
    var translation:CGPoint = .zero
    var initialTranslation:CGPoint = .zero


    
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
        
        enableZoom()
        enablePan()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        arView.scene.background.contents = UIColor(named: "KeynoteBackground")

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }
    
    func enableZoom() {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        arView.isUserInteractionEnabled = true
        arView.addGestureRecognizer(gesture)
      }

    func enablePan() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(startPanning(_:)))
        arView.isUserInteractionEnabled = true
        arView.addGestureRecognizer(gesture)
      }

      @objc private func startZooming(_ sender: UIPinchGestureRecognizer) {
          
          switch sender.state {
              
          case .began:
              initialScale = scale
          case .changed:
              scale = initialScale * sender.scale
          case .ended:
              initialScale = scale
          default:
              break
          }
      }
    
    @objc private func startPanning(_ sender: UIPanGestureRecognizer) {
        
        let senderTranslation = sender.translation(in: arView)
        
        switch sender.state {
            
        case .began:
            initialTranslation = translation
        case .changed:
            translation.x = initialTranslation.x + senderTranslation.x
            translation.y = initialTranslation.y + senderTranslation.y
        default:
            break
        }
    }
    
    
}


extension JustMeshViewController: ARSCNViewDelegate {
    // Adding a Mesh Mask
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = arView.device,
              let faceAnchor = anchor as? ARFaceAnchor,
              let faceGeometry = ARSCNFaceGeometry(device: device) else { return nil }
        faceNode = SCNNode(geometry: faceGeometry)
        faceNode.geometry?.firstMaterial?.fillMode = .lines
        printVertices(faceAnchor: faceAnchor, in: faceNode)
        return faceNode
    }
    
    // Updating the Mesh Mask
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard
            let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry
        else { return }
        node.scale = SCNVector3(scale, scale, scale)
        node.position.x += Float(translation.x)/1000
        node.position.y -= Float(translation.y)/1000

        faceGeometry.update(from: faceAnchor.geometry)
        printVertices(faceAnchor: faceAnchor, in: node, addLabel: false)
    }
    
    
    func printVertices(faceAnchor: ARFaceAnchor, in node: SCNNode, addLabel:Bool = true) {
        for index in 0..<faceAnchor.geometry.vertices.count{
//            guard [236, 460, 1076, 1096].contains(index) else {continue}
//            guard index%4 == 0 else {continue}
            if addLabel {
                let text = SCNText(string: String(index), extrusionDepth: 2)
                let material = SCNMaterial()
                material.diffuse.contents = UIColor.green
                material.specular.contents = UIColor.green
                text.materials = [material]
                
                let newNode = SCNNode()
                newNode.position =  SCNVector3Make(faceAnchor.geometry.vertices[index].x*1.0,faceAnchor.geometry.vertices[index].y*1.0,faceAnchor.geometry.vertices[index].z)
                newNode.scale = SCNVector3(x:0.00025, y:0.00025, z:0.0001)
                newNode.geometry = text
                node.addChildNode(newNode)
                labels[index] = newNode
            } else {
                let position = SCNVector3Make(faceAnchor.geometry.vertices[index].x*1.0,faceAnchor.geometry.vertices[index].y*1.0,faceAnchor.geometry.vertices[index].z)
//                print("Vertice \(index) = ", position)
                labels[index]?.position = position
//                print()
            }
        }
    }
}
