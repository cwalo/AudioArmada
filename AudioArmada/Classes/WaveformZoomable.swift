//
//  WaveformZoomable.swift
//  AudioArmada
//
//  Created by Corey Walo on 3/31/17.
//  Copyright © 2017 Corey Walo. All rights reserved.
//

import Foundation
import AVFoundation
import Accelerate

public enum WaveformStyle {
    case detail, soundcloud
}

public class WaveformZoomable : UIView {
    
    public var zoomFactor: Float = 1.0 {
        didSet {
            if zoomFactor > 1.0 {
                zoomFactor = 1.0
            }
            else if zoomFactor < 0.01 {
                zoomFactor = 0.01
            }
        }
    }
    
    public var style: WaveformStyle = .detail {
        didSet {
            self.reload(zoomFactor: zoomFactor)
        }
    }
    
    struct readFile {
        static var floatValuesLeft = [Float]()
        static var floatValuesRight = [Float]()
        static var leftPoints = [CGPoint]()
        static var rightPoints = [CGPoint]()
        static var populated = false
    }
    
    public convenience init(withFile: URL, style: WaveformStyle = .detail) {
        self.init()
        
        openFile(withFile)
        
        self.style = style
    }
    
    public func openFile(_ file: URL) {
        let audioFile = try! AVAudioFile(forReading: file)
        
        // specify the format we WANT for the buffer
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: audioFile.fileFormat.sampleRate, channels: audioFile.fileFormat.channelCount, interleaved: false)
        
        // initialize and fill the buffer
        let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: UInt32(audioFile.length))
        try! audioFile.read(into: buffer)
        
        // copy buffer to readFile struct
        readFile.floatValuesLeft = Array(UnsafeBufferPointer(start: buffer.floatChannelData?[0], count:Int(buffer.frameLength)))
        
        readFile.populated = true
        
        reload(zoomFactor: zoomFactor)
    }
    
    public func reload(zoomFactor: Float = 1.0) {
        self.zoomFactor = zoomFactor
        setNeedsDisplay()
    }
    
    func makePoints() {
        if !readFile.populated { return }
        
        let viewWidth = bounds.width
        
        let sampleCount = Int(Float(readFile.floatValuesLeft.count) * zoomFactor)
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
        vDSP_vabs(readFile.floatValuesLeft, 1, &processingBuffer, 1, vDSP_Length(sampleCount))
        
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
        readFile.leftPoints = maxSamplesBuffer.enumerated().map({ (index, value) -> CGPoint in
            let normalized = normalizeForDisplay(value)
            let point = CGPoint(x: CGFloat(index), y: CGFloat(normalized))
            return point
        })
        
        // Interpolate points for smoother drawing
        for (index, point) in readFile.leftPoints.enumerated() {
            if index > 0 {
                let interpolatedPoint = CGPoint.lerp(start: readFile.leftPoints[index - 1], end: point, t: 0.5)
                readFile.leftPoints[index] = interpolatedPoint
            }
        }
    }
        
    func drawDetailedWaveform(_ rect: CGRect) {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0.0, y: rect.height/2))
        
        // left channel
        
        for point in readFile.leftPoints {
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
    
    func drawSoundcloudWaveform(_ rect: CGRect) {
        let path = UIBezierPath()
        let pixelWidth: CGFloat = 2.0
        let pixelSpacing: CGFloat = 2.0
        
        path.move(to: CGPoint(x: 0.0, y: rect.height/2))
    
        // left channel
        
        var index = 0
        
        while index < readFile.leftPoints.count {
            let point = readFile.leftPoints[index]
            
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
