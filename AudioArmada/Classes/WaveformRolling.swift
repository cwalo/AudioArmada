//
//  WaveformRolling.swift
//  AudioArmada
//
//  Created by Corey Walo on 4/5/17.
//  Copyright © 2017 Corey Walo. All rights reserved.
//

import Foundation
import UIKit
import Accelerate

public class WaveformRolling : WaveformZoomable {
    
    public var history: Float = 1.0 {
        didSet {
            if history > 1.0 {
                history = 1.0
            }
            else if history < 0.01 {
                history = 0.01
            }
            
            self.setNeedsDisplay()
        }
    }
    
    private var buffer = [Float]()
    private var points = [CGPoint]()
    
    public func updateWithBuffer(_ buffer: [Float]) {
        // buffer
        let toRemove = Int((history * Float(self.buffer.count)))
        if self.buffer.count > 0 && toRemove < self.buffer.count  {
            self.buffer.removeSubrange(0...toRemove)
        }

        self.buffer.append(contentsOf: buffer)
        
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
    }
    
    override func makePoints() {
        if buffer.count == 0 { return }
        
        let viewWidth = bounds.width
        
        let sampleCount = Int(Float(buffer.count) * zoomFactor)
        //        print(sampleCount)
        
        // grab every nth sample (samplesPerPixel)
        let samplesPerPixel = Int(floor(Float(sampleCount) / Float(viewWidth)))
        //        print(samplesPerPixel)
        
        // the expected sample count
        let reducedSampleCount = sampleCount / samplesPerPixel
        //        print(reducedSampleCount)
        
        // left channel
        var processingBuffer = [Float](repeating: 0.0,
                                       count: sampleCount)
        
        // get absolute values
        vDSP_vabs(buffer, 1, &processingBuffer, 1, vDSP_Length(sampleCount))
        
        // This is supposed to do what I'm doing below - using a sliding window to find maximums, but it was producing strange results
        // vDSP_vswmax(processingBuffer, samplePrecision, &maxSamplesBuffer, 1, newSampleCount, vDSP_Length(samplePrecision))
        
        // Instead, we use a for loop with a stride of length samplePrecision to specify a range of samples
        // This range is passed to our own maximumIn() method
        
        var maxSamplesBuffer = [Float](repeating: 0.0,
                                       count: reducedSampleCount)
        
        var offset = 0
        
        for i in stride(from: 0, to: sampleCount-samplesPerPixel, by: samplesPerPixel) {
            maxSamplesBuffer[offset] = maximumIn(processingBuffer, from: i, to: i+samplesPerPixel)
            offset = offset + 1
        }
        
        // Convert the maxSamplesBuffer values to CGPoints for drawing
        // We also normalize them for display here
        points = maxSamplesBuffer.enumerated().map({ (index, value) -> CGPoint in
            let normalized = normalizeForDisplay(value)
            let point = CGPoint(x: CGFloat(index), y: CGFloat(normalized))
            return point
        })
        
        // Interpolate points for smoother drawing
        for (index, point) in points.enumerated() {
            if index > 0 {
                let interpolatedPoint = CGPoint.lerp(start: points[index - 1], end: point, t: 0.5)
                points[index] = interpolatedPoint
            }
        }
    }
    
    
    override func drawDetailedWaveform(_ rect: CGRect) {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0.0, y: rect.height/2))
        
        for point in points {
            let drawFrom = CGPoint(x: point.x, y: path.currentPoint.y)
            
            path.move(to: drawFrom)
            
            // bottom half
            let drawPointBottom = CGPoint(x: point.x, y: path.currentPoint.y + (point.y))
            path.addLine(to: drawPointBottom)
            
            path.close()
            
            // top half
            let drawPointTop = CGPoint(x: point.x, y: path.currentPoint.y - (point.y))
            path.addLine(to: drawPointTop)
            
            path.close()
        }
        
        UIColor.orange.set()
        path.stroke()
        path.fill()
    }
    
    override func drawSoundcloudWaveform(_ rect: CGRect) {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0.0, y: rect.height/2))
        
        var index = 0
        
        while index < points.count {
            let point = points[index]
            
            let drawFrom = CGPoint(x: point.x, y: path.currentPoint.y)
            
            // bottom half
            path.move(to: drawFrom)
            
            let drawPointBottom = CGPoint(x: point.x, y: path.currentPoint.y + (point.y))
            path.addLine(to: drawPointBottom)
            path.addLine(to: CGPoint(x: drawPointBottom.x + pixelWidth, y: drawPointBottom.y))
            path.addLine(to: CGPoint(x: drawFrom.x + pixelWidth, y: drawFrom.y))
            
            path.close()
            
            // top half
            path.move(to: drawFrom)
            
            let drawPointTop = CGPoint(x: point.x, y: path.currentPoint.y - (point.y))
            path.addLine(to: drawPointTop)
            path.addLine(to: CGPoint(x: drawPointTop.x + pixelWidth, y: drawPointTop.y))
            path.addLine(to: CGPoint(x: drawFrom.x + pixelWidth, y: drawFrom.y))
            
            path.close()
            
            // increment index
            index = index + Int(pixelWidth) + Int(pixelSpacing)
        }
        
        UIColor.orange.set()
        path.stroke()
        path.fill()
    }
    
    override public func draw(_ rect: CGRect) {
        makePoints()
                
        // this clears the rect
        backgroundColor = .black
        
        switch style {
        case .detail:
            drawDetailedWaveform(rect)
        case .soundcloud:
            drawSoundcloudWaveform(rect)
        }
    }
}
