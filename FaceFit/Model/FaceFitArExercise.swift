//
//  FaceFitArExercise.swift
//  FaceFit
//
//  Created by Ricardo Venieris on 06/10/22.
//

import Foundation


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
    
    func test(for blendShapes: BlendShapes)->FaceFitArStatus {
        
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
