//
//  FaceFitArMovement.swift
//  FaceFit
//
//  Created by Ricardo Venieris on 06/10/22.
//

import Foundation


class FaceFitArMovement {
    let blendShape: BlendShapeLocation
    let bottonValue: Float
    let upperValue: Float
    let name:String
    var lastValue:Float = 0
    
    init(blendShape: BlendShapeLocation ,bottonValue: Float ,upperValue: Float = 1 ,name:String) {
        self.blendShape = blendShape
        self.bottonValue = bottonValue
        self.upperValue = upperValue
        self.name = name
    }
    
    
    func isExecuting(for value:NSNumber?)->Bool {
        lastValue = (value as? Float) ?? 0
        return bottonValue <= lastValue && lastValue <= upperValue
    }
    
    
    
        // L & R Switched due to match ARFaceAnchor.BlendShape Values
    static let eyeBlink_L   = FaceFitArMovement(blendShape: .eyeBlinkRight  , bottonValue: 0.55, name: "Eye Wink Left")
    static let mouthSmile_L = FaceFitArMovement(blendShape: .mouthSmileRight, bottonValue: 0.35, name: "Mouth Smile Left")
    static let browDown_L   = FaceFitArMovement(blendShape: .browDownLeft   , bottonValue: 0.50, name: "Brow Down Left")
    static let eyeBlink_R   = FaceFitArMovement(blendShape: .eyeBlinkLeft   , bottonValue: 0.55, name: "Eye Wink Right")
    static let mouthSmile_R = FaceFitArMovement(blendShape: .mouthSmileLeft , bottonValue: 0.35, name: "Mouth Smile Right")
    static let browDown_R   = FaceFitArMovement(blendShape: .browDownRight  , bottonValue: 0.50, name: "Brow Down Right")
    static let browInnerUp  = FaceFitArMovement(blendShape: .browInnerUp    , bottonValue: 0.50, name: "Brow Up")
    static let cheekPuff    = FaceFitArMovement(blendShape: .cheekPuff      , bottonValue: 0.80, name: "Cheek Puff")
    static let jawOpen      = FaceFitArMovement(blendShape: .jawOpen        , bottonValue: 0.70, name: "Jaw Open")
    static let mouthPucker  = FaceFitArMovement(blendShape: .mouthPucker    , bottonValue: 0.80, name: "Mouth Pucker")
    static let tongueOut    = FaceFitArMovement(blendShape: .tongueOut      , bottonValue: 0.99, name: "Tongue Out")
    
}
