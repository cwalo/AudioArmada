//
//  UIView+Normalize.swift
//  AudioArmada
//
//  Created by Corey Walo on 4/3/17.
//  Copyright © 2017 Corey Walo. All rights reserved.
//

import Foundation

public extension UIView {
    public func normalizeForDisplay(_ value: Float) -> Float {
        let maxHeight = Float(bounds.height)
        let minHeight = Float(maxHeight / 2.0)
        let normalized = value * minHeight
        return normalized
    }
}
