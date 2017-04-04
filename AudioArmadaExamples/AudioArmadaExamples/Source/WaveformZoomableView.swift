//
//  WaveformZoomableView.swift
//  AudioArmadaExamples
//
//  Created by Corey Walo on 3/31/17.
//  Copyright © 2017 Corey Walo. All rights reserved.
//

import UIKit
import Restraint
import AudioArmada

class WaveformZoomableView: UIView {
    
    let styleToggle = UISegmentedControl()
    let waveform = WaveformZoomable()
    let slider = UISlider()
    let sliderLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
        backgroundColor = .white
        
        addSubview(styleToggle)
        addSubview(waveform)
        addSubview(slider)
        addSubview(sliderLabel)
        
        Restraint(styleToggle, .bottom, .equal, waveform, .top, 1.0, -20.0).addToView(self)
        Restraint(styleToggle, .centerX, .equal, self, .centerX).addToView(self)
        
        Restraint(waveform, .leading, .equal, self, .leading).addToView(self)
        Restraint(waveform, .trailing, .equal, self, .trailing).addToView(self)
        Restraint(waveform, .height, .equal, 200.0).addToView(self)
        Restraint(waveform, .centerY, .equal, self, .centerY).addToView(self)
        
        Restraint(slider, .width, .equal, 100.0).addToView(self)
        Restraint(slider, .centerX, .equal, self, .centerX).addToView(self)
        Restraint(slider, .top, .equal, waveform, .bottom, 1.0, 20.0).addToView(self)
        
        Restraint(sliderLabel, .left, .equal, slider, .right, 1.0, 10.0).addToView(self)
        Restraint(sliderLabel, .centerY, .equal, slider, .centerY).addToView(self)
    }

}
