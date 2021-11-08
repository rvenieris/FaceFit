//
//  ArFaceExercise.swift
//  FaceFit
//
//  Created by Ricardo Venieris on 03/11/21.
//

import ARKit



struct FaceFitArRoutine {
    
    // Presseted exercises
    static let instantBeautify = FaceFitArRoutine(name: "Instant Beautify",
                                                  exercises: [.WinkLeft, .WinkRight, .FaceStretch, .FaceContract],
                                                  rounds: 2)
    
    
    var name:String
    let exercises:[FaceFitArExercise]
    let rounds:Int
    
    var step:Int = -1
    var currentRound:Int = -1
    var status:FaceFitArStatus = .notStarted
    
    var canRun:Bool {status == .notStarted || status == .inExecution}

    var currentExercise:FaceFitArExercise? {
        guard step >= 0 && step < exercises.count else {return nil}
        return exercises[step]
    }
    
    mutating func start_reset() {
        currentRound = 0
        step = 0
        status = .inExecution
        exercises.forEach {$0.reset()}
    }
    
    mutating func stop() {
        currentRound = -1
        step = -1
        status = .notStarted
    }
    
    mutating func gotoNextStep() {
        guard canRun else {return}
        
        step += 1
        if step >= exercises.count {
            currentRound += 1
            step = 0
            exercises.forEach {$0.reset()}
        }
        
        if currentRound >= rounds {
            status = .executed
            currentRound = -1
            step = -1
        }
    }
    

    
    mutating func update(from blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber]) {
        guard canRun else {return}
        
        let stepStatus = currentExercise?.test(for: blendShapes) ?? .notStarted
        
        switch stepStatus {
        case .executed:
            gotoNextStep()
        case .failed:
            currentExercise?.reset()
        default:
            break
        }
        
    }
}

class FaceFitArExercise {
    
    var name:String
    let pose: FaceFitArPose
    let timeToRun: TimeInterval
    var status:FaceFitArStatus
    var timeRemaining:TimeInterval {
        let timeRemaining = timeToRun + (startExecutionTime ?? Date()).timeIntervalSinceNow
        return timeRemaining < 0 ? 0 : timeRemaining
    }
    var tip:String {pose.tip}
    
    private var startExecutionTime:Date?
    
    init(name:String? = nil, pose:FaceFitArPose, timeToRun: TimeInterval, status:FaceFitArStatus = .notStarted) {
        self.name = name ?? pose.name
        self.pose = pose
        self.timeToRun = timeToRun
        self.status = status
    }
    
    func test(for blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber])->FaceFitArStatus {
        
        let isExecuting = pose.isExecuting(for: blendShapes)
        
        if isExecuting {
            
            switch status {
            case .notStarted:
                startExecutionTime = Date()
                status = .inExecution
                break
                
            case .inExecution:
                status = timeRemaining.isZero ? .executed : .inExecution
            default:
                break
            }
            
        } else { // if not executing
            startExecutionTime = nil
            
            switch status {
            case .inExecution:
                status = .failed
                break
            default:
                break
            }
        }
        
        return status
    }
    
    func reset() {
        status = .notStarted
        startExecutionTime = nil
    }
    
    static let WinkLeft = FaceFitArExercise(pose: .WinkLeft, timeToRun: 1)
    static let WinkRight = FaceFitArExercise(pose: .WinkRight, timeToRun: 1)
    static let FaceStretch = FaceFitArExercise(pose: .FaceStretch, timeToRun: 1)
    static let FaceContract = FaceFitArExercise(pose: .FaceContract, timeToRun: 1)


}

struct FaceFitArPose {
    let name:String
    let moves:[FaceFitArMovement]
    let tip:String
    
    func isExecuting(for blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber])->Bool {
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

class FaceFitArMovement {
    let blendShape: ARFaceAnchor.BlendShapeLocation
    let bottonValue: Float
    let upperValue: Float
    let name:String
    var lastValue:Float = 0
    
    init(blendShape: ARFaceAnchor.BlendShapeLocation ,bottonValue: Float ,upperValue: Float = 1 ,name:String) {
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

extension Dictionary where Key == ARFaceAnchor.BlendShapeLocation, Value: NSNumber {
    func isExecuting(_ movements: [FaceFitArMovement])->Bool {
        movements.reduce(true, {a, b in
            b.isExecuting(for: self[b.blendShape]) && a // Keep a as last in operation to prevent pre-exit
        })

    }
}

enum BlendShape:CaseIterable {
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
}

enum FaceFitArStatus {
    case notStarted
    case inExecution
    case executed
    case failed
}
