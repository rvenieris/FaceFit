//
//  Extensions.swift
//  FaceFit
//
//  Created by Ricardo Venieris on 05/11/21.
//

import Foundation

extension Dictionary where Key == BlendShapeLocation, Value: NSNumber {
    func isExecuting(_ movements: [FaceFitArMovement])->Bool {
        movements.reduce(true, {a, b in
            b.isExecuting(for: self[b.blendShape]) && a // Keep a as last in operation to prevent pre-exit
        })
        
    }
}

extension Float {
    var string2F:String {return String(format: "%.2f", self)}
}

extension Double {
    var string2F:String {return String(format: "%.2f", self)}
}

