//
//  ViewController.swift
//  FaceFit
//
//  Created by Ricardo Venieris on 03/11/21.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARSCNView!
    
    var leftNames:[UILabel] = []
    var leftValues:[String:UILabel] = [:]
    let leftKeys:[String] = [
        "browDown_L",
        "browOuterUp_L",
        "cheekSquint_L",
        "eyeBlink_L",
        "eyeLookDown_L",
        "eyeLookIn_L",
        "eyeLookOut_L",
        "eyeLookUp_L",
        "eyeSquint_L",
        "eyeWide_L",
        "jawLeft",
        "mouthDimple_L",
        "mouthFrown_L",
        "mouthLowerDown_L",
        "mouthPress_L",
        "mouthSmile_L",
        "mouthStretch_L",
        "mouthUpperUp_L",
        "mouthLeft",
        "noseSneer_L"]
    
    var rightNames:[UILabel] = []
    var rightValues:[String:UILabel] = [:]
    let rightKeys:[String] = [
        "browDown_R",
        "browOuterUp_R",
        "cheekSquint_R",
        "eyeBlink_R",
        "eyeLookDown_R",
        "eyeLookIn_R",
        "eyeLookOut_R",
        "eyeLookUp_R",
        "eyeSquint_R",
        "eyeWide_R",
        "jawRight",
        "mouthDimple_R",
        "mouthFrown_R",
        "mouthLowerDown_R",
        "mouthPress_R",
        "mouthSmile_R",
        "mouthStretch_R",
        "mouthUpperUp_R",
        "mouthRight",
        "noseSneer_R"]
    
    var otherNames:[UILabel] = []
    var otherValues:[String:UILabel] = [:]
    let otherKeys:[String] = [
        "browInnerUp",
        "cheekPuff",
        "jawForward",
        "jawOpen",
        "mouthClose",
        "mouthFunnel",
        "mouthPucker",
        "mouthRollLower",
        "mouthRollUpper",
        "mouthShrugLower",
        "mouthShrugUpper",
        "tongueOut"]
    
    var allValues:[String:UILabel] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device")
        }
        
        arView.delegate = self
    }
    
    func create(keys:inout [UILabel], values:inout [String:UILabel], from labels: [String], col:CGFloat, line:CGFloat ) {
        guard keys.isEmpty, values.isEmpty, !labels.isEmpty else {return}
        
        let column = ((self.view.frame.width/2) * col) + 20
        var nextLine =  ((self.view.frame.height/2) * line) + 100
        for ind in 0..<labels.count {
            
            let key = UILabel(frame: CGRect(x: column, y: nextLine, width: 150, height: 15))
            key.text = labels[ind] + ": "
            key.textAlignment = .right
            key.adjustsFontSizeToFitWidth = true
            key.backgroundColor = UIColor(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
            key.textColor = .black
            keys.append(key)
            self.view.addSubview(key)

            let value = UILabel(frame: CGRect(x: key.frame.maxX + 2, y: nextLine, width: 30, height: key.frame.height))
            value.text = "-.--"
            value.textAlignment = .left
            value.adjustsFontSizeToFitWidth = true
            value.backgroundColor = key.backgroundColor
            value.textColor = key.textColor
            values[labels[ind]] = value
            self.view.addSubview(value)

            nextLine = key.frame.maxY + 2
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        create(keys: &leftNames, values: &leftValues, from: leftKeys, col: 0, line: 0)
        create(keys: &rightNames, values: &rightValues, from: rightKeys, col: 1, line: 0)
        create(keys: &otherNames, values: &otherValues, from: otherKeys, col: 0.5, line: 1)
        allValues.merge(leftValues) { (current, _) in current }
        allValues.merge(rightValues) { (current, _) in current }
        allValues.merge(otherValues) { (current, _) in current }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 1
        let configuration = ARFaceTrackingConfiguration()
        
        // 2
        
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 1
        arView.session.pause()
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        
        
        
        print("\n\n\n\n\n\n\n\n\n")
        print("  ", Date())
        print("┌──────────────────────────┐")
        print("│           Left           │")
        print("├──────────────────────────┤")
        leftKeys.forEach { item in
            print("│\((item+"              ").prefix(16)) = \(leftValues[item]?.text ?? "-.--")   │")
        }
        print("└──────────────────────────┘")
        print("┌──────────────────────────┐")
        print("│           Right          │")
        print("├──────────────────────────┤")
        rightKeys.forEach { item in
            print("│\((item+"              ").prefix(16)) = \(rightValues[item]?.text ?? "-.--")   │")
        }
        print("└──────────────────────────┘")
        print("┌──────────────────────────┐")
        print("│           Other          │")
        print("├──────────────────────────┤")
        otherKeys.forEach { item in
            print("│\((item+"              ").prefix(16)) = \(otherValues[item]?.text ?? "-.--")   │")
        }
        print("└──────────────────────────┘")
        
    }

    
}


// 1
extension ViewController: ARSCNViewDelegate {
    // 2
    
    // Adding a Mesh Mask
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        // 3
        guard let device = arView.device else { return nil }
        
        // 4
        let faceGeometry = ARSCNFaceGeometry(device: device)
        
        // 5
        let node = SCNNode(geometry: faceGeometry)
        
        // 6
        node.geometry?.firstMaterial?.fillMode = .lines
        
        // 7
        return node
    }
    
    
    // Updating the Mesh Mask
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        // 2
        guard
            let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry
        else { return }
        
        // 3
        faceGeometry.update(from: faceAnchor.geometry)
        
        // Call a custom update
        update(withFaceAnchor: faceAnchor)
    }
    
    func update(withFaceAnchor faceAnchor: ARFaceAnchor) {
        
        for item in faceAnchor.blendShapes {
            let key = String("\(item.key)".split(separator: " ")[1].split(separator: ")")[0])
            let value = item.value as? Float ?? 0
            if let valueLabel = allValues[key] {
                DispatchQueue.main.async {
                    valueLabel.text = String(format: "%.2f", value)
                }
            }
        }
    }
    
    
}
