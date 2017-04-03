//
//  CGPoint+Operators.swift
//  AudioArmada
//
//  Created by Corey Walo on 4/3/17.
//  Copyright © 2017 Corey Walo. All rights reserved.
//

import Foundation

public extension CGPoint {
    static public func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static public func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static public func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }
    
    static public func lerp(start: CGPoint, end: CGPoint, t: CGFloat) -> CGPoint {
        return start + (end - start) * t
    }
}
