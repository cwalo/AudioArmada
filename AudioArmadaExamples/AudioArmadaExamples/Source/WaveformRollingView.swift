//
//  WaveformRollingView.swift
//  AudioArmadaExamples
//
//  Created by Corey Walo on 4/5/17.
//  Copyright © 2017 Corey Walo. All rights reserved.
//

import UIKit
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
        
        styleToggle.translatesAutoresizingMaskIntoConstraints = false
        waveform.translatesAutoresizingMaskIntoConstraints = false
        sliderTitle.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        sliderLabel.translatesAutoresizingMaskIntoConstraints = false
        historySliderTitle.translatesAutoresizingMaskIntoConstraints = false
        historySlider.translatesAutoresizingMaskIntoConstraints = false
        historySliderLabel.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        
        styleToggle.bottomAnchor.constraint(equalTo: waveform.topAnchor, constant: -20.0).isActive = true
        styleToggle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        waveform.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        waveform.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        waveform.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        waveform.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        sliderTitle.trailingAnchor.constraint(equalTo: slider.leadingAnchor, constant: -10.0).isActive = true
        sliderTitle.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true
        
        slider.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        slider.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        slider.topAnchor.constraint(equalTo: waveform.bottomAnchor, constant: 20.0).isActive = true
        
        sliderLabel.leadingAnchor.constraint(equalTo: slider.trailingAnchor, constant: 10.0).isActive = true
        sliderLabel.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true
        
        historySliderTitle.trailingAnchor.constraint(equalTo: historySlider.leadingAnchor, constant: -10.0).isActive = true
        historySliderTitle.centerYAnchor.constraint(equalTo: historySlider.centerYAnchor).isActive = true
        
        historySlider.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        historySlider.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        historySlider.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 20.0).isActive = true
        
        historySliderLabel.leadingAnchor.constraint(equalTo: historySlider.trailingAnchor, constant: 10.0).isActive = true
        historySliderLabel.centerYAnchor.constraint(equalTo: historySlider.centerYAnchor).isActive = true

        playButton.topAnchor.constraint(equalTo: historySlider.bottomAnchor, constant: 15.0).isActive = true
        playButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        stopButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 15.0).isActive = true
        stopButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

    }
}
