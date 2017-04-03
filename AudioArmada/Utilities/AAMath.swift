//
//  AAMath.swift
//  AudioArmada
//
//  Created by Corey Walo on 4/3/17.
//  Copyright © 2017 Corey Walo. All rights reserved.
//

import Foundation

// This implementation is nearly identical to vDSP_vswmax, buuuut we're doing it in swift so I'm certain there's a performance hit
public func maximumIn(_ array: [Float], from: Int, to: Int) -> Float {
    var max: Float = -Float.infinity
    
    for index in from...to {
        if array[index] > max {
            max = array[index]
        }
    }
    
    return max
}

public func minimumIn(_ array: [Float], from: Int, to: Int) -> Float {
    var min: Float = Float.infinity
    
    for index in from...to {
        if array[index] < min {
            min = array[index]
        }
    }
    
    return min
}
