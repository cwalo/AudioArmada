//
//  WaveformRollingView.swift
//  AudioArmadaExamples
//
//  Created by Corey Walo on 4/5/17.
//  Copyright © 2017 Corey Walo. All rights reserved.
//

import Foundation
import UIKit
import Restraint
import AudioArmada

class WaveformRollingView : UIView {
    let styleToggle = UISegmentedControl()
    let waveform = WaveformRolling()
    
    let sliderTitle = UILabel()
    let slider = UISlider()
    let sliderLabel = UILabel()
    
    let historySliderTitle = UILabel()
    let historySlider = UISlider()
    let historySliderLabel = UILabel()
    
    let playButton = UIButton()
    let stopButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
        backgroundColor = .white
        
        sliderTitle.text = "Zoom"
        historySliderTitle.text = "History"
        
        addSubview(styleToggle)
        addSubview(waveform)
        addSubview(sliderTitle)
        addSubview(slider)
        addSubview(sliderLabel)
        addSubview(historySliderTitle)
        addSubview(historySlider)
        addSubview(historySliderLabel)
        addSubview(playButton)
        addSubview(stopButton)
        
        Restraint(styleToggle, .bottom, .equal, waveform, .top, 1.0, -20.0).addToView(self)
        Restraint(styleToggle, .centerX, .equal, self, .centerX).addToView(self)
        
        Restraint(waveform, .leading, .equal, self, .leading).addToView(self)
        Restraint(waveform, .trailing, .equal, self, .trailing).addToView(self)
        Restraint(waveform, .height, .equal, 200.0).addToView(self)
        Restraint(waveform, .centerY, .equal, self, .centerY).addToView(self)
        
        Restraint(sliderTitle, .right, .equal, slider, .left, 1.0, -10.0).addToView(self)
        Restraint(sliderTitle, .centerY, .equal, slider, .centerY).addToView(self)
        
        Restraint(slider, .width, .equal, 100.0).addToView(self)
        Restraint(slider, .centerX, .equal, self, .centerX).addToView(self)
        Restraint(slider, .top, .equal, waveform, .bottom, 1.0, 20.0).addToView(self)
        
        Restraint(sliderLabel, .left, .equal, slider, .right, 1.0, 10.0).addToView(self)
        Restraint(sliderLabel, .centerY, .equal, slider, .centerY).addToView(self)
        
        Restraint(historySliderTitle, .right, .equal, historySlider, .left, 1.0, -10.0).addToView(self)
        Restraint(historySliderTitle, .centerY, .equal, historySlider, .centerY).addToView(self)
        
        Restraint(historySlider, .width, .equal, 100.0).addToView(self)
        Restraint(historySlider, .centerX, .equal, self, .centerX).addToView(self)
        Restraint(historySlider, .top, .equal, slider, .bottom, 1.0, 20.0).addToView(self)
        
        Restraint(historySliderLabel, .left, .equal, historySlider, .right, 1.0, 10.0).addToView(self)
        Restraint(historySliderLabel, .centerY, .equal, historySlider, .centerY).addToView(self)
        
        Restraint(playButton, .top, .equal, historySlider, .bottom, 1.0, 15.0).addToView(self)
        Restraint(playButton, .centerX, .equal, self, .centerX).addToView(self)
        
        Restraint(stopButton, .top, .equal, playButton, .bottom, 1.0, 15.0).addToView(self)
        Restraint(stopButton, .centerX, .equal, self, .centerX).addToView(self)

    }
}
