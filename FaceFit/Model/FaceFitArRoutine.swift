//
//  FaceFitArRoutine.swift
//  FaceFit
//
//  Created by Ricardo Venieris on 06/10/22.
//

import Foundation



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
    
    
    
    mutating func update(from blendShapes: BlendShapes) {
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
