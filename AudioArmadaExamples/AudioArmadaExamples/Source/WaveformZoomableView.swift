//
//  WaveformZoomableView.swift
//  AudioArmadaExamples
//
//  Created by Corey Walo on 3/31/17.
//  Copyright © 2017 Corey Walo. All rights reserved.
//

import UIKit
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
        
        styleToggle.translatesAutoresizingMaskIntoConstraints = false
        waveform.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        sliderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        styleToggle.bottomAnchor.constraint(equalTo: waveform.topAnchor, constant: -20.0).isActive = true
        styleToggle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        waveform.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        waveform.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        waveform.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        waveform.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        slider.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        slider.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        slider.topAnchor.constraint(equalTo: waveform.bottomAnchor, constant: 20.0).isActive = true
        
        sliderLabel.leadingAnchor.constraint(equalTo: slider.trailingAnchor, constant: 10.0).isActive = true
        sliderLabel.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true
    }
}
