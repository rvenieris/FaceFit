//
//  FaceFitArPose.swift
//  FaceFit
//
//  Created by Ricardo Venieris on 06/10/22.
//

import Foundation


struct FaceFitArPose {
    let name:String
    let moves:[FaceFitArMovement]
    let tip:String
    
    func isExecuting(for blendShapes: BlendShapes)->Bool {
        return blendShapes.isExecuting(moves)
    }
    
    static let WinkLeft = FaceFitArPose(name: "Wink Left", moves: [.eyeBlink_L, .mouthSmile_L],
                                        tip:"Wink eye and side Smile left")
    static let WinkRight = FaceFitArPose(name: "Wink Right", moves: [.eyeBlink_R, .mouthSmile_R],
                                         tip:"Wink eye and side Smile right")
    static let FaceStretch = FaceFitArPose(name: "Face Stretch", moves: [.browInnerUp, .jawOpen],
                                           tip:"open eyes and mouth vigorously")
    static let FaceContract = FaceFitArPose(name: "Face Contract", moves: [.browDown_L, .browDown_R, .mouthPucker],
                                            tip:"Eyebrows down and make a pout with your mouth")
}
