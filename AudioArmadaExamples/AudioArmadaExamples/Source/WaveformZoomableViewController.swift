//
//  WaveformZoomableViewController.swift
//  AudioArmadaExamples
//
//  Created by Corey Walo on 3/31/17.
//  Copyright © 2017 Corey Walo. All rights reserved.
//

import UIKit
import AudioArmada

class WaveformZoomableViewController: UIViewController, ExampleViewController {
    
    static var displayName: String = "WaveformZoomable"
    
    var styleToggle: UISegmentedControl!
    var waveform: WaveformZoomable!
    var slider: UISlider!
    var sliderLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = WaveformZoomableViewController.displayName
        
        // open the audio file and set the display style
        guard let file = Bundle.main.url(forResource: "drumLoop", withExtension: "wav") else { return }
        waveform.openFile(file)
        
        styleToggle.addTarget(self, action: #selector(self.didToggleStyle(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(self.didSlide(_:)), for: .valueChanged)
    }
    
    func didSlide(_ sender: UISlider) {
        // invert the values that represent the zoomFactor since we want to zoom IN as we slide left to right
        let zoomFactor = sender.maximumValue - sender.value + sender.minimumValue;
        sliderLabel.text = "\(zoomFactor * 100.0) %"
        waveform.reload(zoomFactor: zoomFactor)
    }
    
    func didToggleStyle(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            waveform.style = .detail
        case 1:
            waveform.style = .soundcloud
        default:
            break
        }
    }
    
    override func loadView() {
        let waveformView = WaveformZoomableView()
        styleToggle = waveformView.styleToggle
        waveform = waveformView.waveform
        slider = waveformView.slider
        sliderLabel = waveformView.sliderLabel
        
        styleToggle.insertSegment(withTitle: "Detailed", at: 0, animated: false)
        styleToggle.insertSegment(withTitle: "Soundcloud", at: 1, animated: false)
        styleToggle.selectedSegmentIndex = 0
        
        // set min-max to show 1%-100% of the waveform
        slider.minimumValue = 0.01
        slider.maximumValue = 1.0
        slider.setValue(slider.minimumValue, animated: false)
        
        sliderLabel.text = "100.0 %"

        view = waveformView
    }
}

