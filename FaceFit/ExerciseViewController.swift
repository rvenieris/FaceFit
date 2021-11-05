//
//  ExerciseViewController.swift
//  FaceFit
//
//  Created by Ricardo Venieris on 04/11/21.
//

import UIKit
import ARKit

class ExerciseViewController: UIViewController {
    
    @IBOutlet var arView: ARSCNView!
    
    @IBOutlet weak var imageGuide: UIImageView!
    @IBOutlet weak var textGuide: UILabel!
    
    @IBOutlet weak var tipText: UITextField!
    @IBOutlet weak var featureValues: UILabel!
    
    var routine = FaceFitArRoutine.instantBeautify
    var isRunning:Bool {routine.status == .inExecution}
    
    var images:[String:UIImage] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device")
        }
        
        arView.delegate = self
        tipText.isHidden = true
        
        routine.exercises.forEach{ images[$0.name] = UIImage(named: $0.name) }
        images["Congrats"] = UIImage(named: "Congrats")
        images["Fail"] = UIImage(named: "Fail")
        
        UIApplication.shared.isIdleTimerDisabled = true
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
    
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        if isRunning {
            routine.stop()
        } else {
            routine.start_reset()
        }
    }
    
    
}


// 1
extension ExerciseViewController: ARSCNViewDelegate {
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
        node.geometry?.firstMaterial?.diffuse.contents = UIColor(white: 1.0,
                                                                         alpha: 0.3)
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
        routine.update(from: faceAnchor.blendShapes)
        DispatchQueue.main.async { [self] in
            
            
            switch routine.status {
            case .notStarted:
                textGuide.text = "Tap to Start"
                imageGuide.image = nil
            case .inExecution:
                guard let exercise = routine.currentExercise else { return }
                textGuide.text = """
                Round: \(routine.currentRound+1), Step: \(routine.step+1)
                \(exercise.name) for \(exercise.timeRemaining.string2F)
                """
                tipText.isHidden = (exercise.status != .notStarted)
                tipText.text = exercise.tip
                
                imageGuide.image = images[exercise.name]
                
                
                
                featureValues.text = ""
                exercise.pose.moves.forEach { item in
                    featureValues.text! += item.name + " = \(item.lastValue.string2F) → \(item.bottonValue.string2F)"
                    featureValues.text! += (item === exercise.pose.moves.last) ? "" : "\n"
                }
                
                
            case .executed:
                textGuide.text = """
                COGRATULATIONS!
                You Did it
                Tap to Restart
                """
                tipText.isHidden = true
                imageGuide.image = images["Congrats"]
            case .failed:
                textGuide.text = """
                OH NO!
                You Failed
                Tap to Restart
                """
                tipText.isHidden = true
                imageGuide.image = images["Fail"]
            }
            
        }
    }
    
    
}
