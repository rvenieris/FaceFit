//
//  BlendShapes.swift
//  FaceFit
//
//  Created by Ricardo Venieris on 06/10/22.
//

import Foundation
import ARKit

typealias BlendShapeLocation = ARFaceAnchor.BlendShapeLocation
typealias BlendShapes = [ARFaceAnchor.BlendShapeLocation : NSNumber]

enum BlendShape:String, CaseIterable {
        // ┌──────────────────────────┐
        // │           Left           │
        // ├──────────────────────────┤
    case browDown_L
    case browOuterUp_L
    case cheekSquint_L
    case eyeBlink_L
    case eyeLookDown_L
    case eyeLookIn_L
    case eyeLookOut_L
    case eyeLookUp_L
    case eyeSquint_L
    case eyeWide_L
    case jawLeft
    case mouthDimple_L
    case mouthFrown_L
    case mouthLowerDown_L
    case mouthPress_L
    case mouthSmile_L
    case mouthStretch_L
    case mouthUpperUp_L
    case mouthLeft
    case noseSneer_L
    
        // ┌──────────────────────────┐
        // │           Right          │
        // ├──────────────────────────┤
    case browDown_R
    case browOuterUp_R
    case cheekSquint_R
    case eyeBlink_R
    case eyeLookDown_R
    case eyeLookIn_R
    case eyeLookOut_R
    case eyeLookUp_R
    case eyeSquint_R
    case eyeWide_R
    case jawRight
    case mouthDimple_R
    case mouthFrown_R
    case mouthLowerDown_R
    case mouthPress_R
    case mouthSmile_R
    case mouthStretch_R
    case mouthUpperUp_R
    case mouthRight
    case noseSneer_R
    
        // ┌──────────────────────────┐
        // │           Other          │
        // ├──────────────────────────┤
    case browInnerUp
    case cheekPuff
    case jawForward
    case jawOpen
    case mouthClose
    case mouthFunnel
    case mouthPucker
    case mouthRollLower
    case mouthRollUpper
    case mouthShrugLower
    case mouthShrugUpper
    case tongueOut
    
    static private func itS(left  item:String)->Bool {return item.hasSuffix("_L") || item.hasSuffix("Left")}
    static private func itS(right item:String)->Bool {return item.hasSuffix("_R") || item.hasSuffix("Right")}
    static private func itS(other item:String)->Bool {!itS(left: item) && !itS(right: item)}

    static var leftOnes: [String]{ BlendShape.allCases.map{ $0.rawValue }.filter{ itS(left: $0) } }
    static var rightOnes:[String]{ BlendShape.allCases.map{ $0.rawValue }.filter{ itS(right: $0) } }
    static var otherOnes:[String]{ BlendShape.allCases.map{ $0.rawValue }.filter{ itS(other: $0) } }
    
}
