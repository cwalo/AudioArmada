//
//  WaveformRollingViewController.swift
//  AudioArmadaExamples
//
//  Created by Corey Walo on 4/5/17.
//  Copyright © 2017 Corey Walo. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AudioArmada

class WaveformRollingViewController : UIViewController, ExampleViewController {
    static var displayName: String = "WaveformRolling"
    
    var engine: AVAudioEngine!
    var player: AVAudioPlayerNode!
    var file =  AVAudioFile()
    var buffer: AVAudioPCMBuffer!
    
    var styleToggle: UISegmentedControl!
    var waveform: WaveformRolling!
    var slider: UISlider!
    var sliderLabel: UILabel!
    var historySlider: UISlider!
    var historySliderLabel: UILabel!
    var playButton: UIButton!
    var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = WaveformRollingViewController.displayName
        
        styleToggle.addTarget(self, action: #selector(self.didToggleStyle(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(self.didSlide(_:)), for: .valueChanged)
        historySlider.addTarget(self, action: #selector(self.didSlideHistory(_:)), for: .valueChanged)
        
        playButton.addTarget(self, action: #selector(self.didPressPlay), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(self.didPressStop), for: .touchUpInside)
        
        engine = AVAudioEngine()
        player = AVAudioPlayerNode()
        
        guard let url = Bundle.main.url(forResource: "drumLoop", withExtension: "wav") else { return }
        
        file = try! AVAudioFile(forReading: url)
        
        // need to specify the format, because engine channel count is stereo by default
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: file.fileFormat.channelCount, interleaved: false)
        
        buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(file.length))
        try! file.read(into: buffer)
        
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: format)
        
        engine.mainMixerNode.installTap(onBus: 0, bufferSize: 1024, format: format) { (buffer, time) in
            let length = buffer.frameLength
            let floatArray = Array(UnsafeBufferPointer(start: buffer.floatChannelData?[0], count: Int(length)))
            self.waveform.updateWithBuffer(floatArray)
        }
        
        engine.prepare()
        try! engine.start()
    }
    
    func didSlide(_ sender: UISlider) {
        // invert the values that represent the zoomFactor since we want to zoom IN as we slide left to right
        let zoomFactor = sender.maximumValue - sender.value + sender.minimumValue;
        sliderLabel.text = "\(zoomFactor * 100.0) %"
        waveform.reload(zoomFactor: zoomFactor)
    }
    
    func didSlideHistory(_ sender: UISlider) {
        // invert the values that represent the zoomFactor since we want to zoom IN as we slide left to right
        let history = sender.maximumValue - sender.value + sender.minimumValue;
        historySliderLabel.text = "\(history * 100.0) %"
        waveform.history = history
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
    
    func didPressPlay() {
        if engine.isRunning {
            player.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
            player.play()
        }
    }
    
    func didPressStop() {
        if engine.isRunning {
            player.stop()
        }
    }
    
    override func loadView() {
        let waveformView = WaveformRollingView()
        styleToggle = waveformView.styleToggle
        waveform = waveformView.waveform
        slider = waveformView.slider
        sliderLabel = waveformView.sliderLabel
        historySlider = waveformView.historySlider
        historySliderLabel = waveformView.historySliderLabel
        
        styleToggle.insertSegment(withTitle: "Detailed", at: 0, animated: false)
        styleToggle.insertSegment(withTitle: "Soundcloud", at: 1, animated: false)
        styleToggle.selectedSegmentIndex = 0
        
        // set min-max to show 1%-100% of the waveform
        slider.minimumValue = 0.01
        slider.maximumValue = 1.0
        slider.setValue(slider.minimumValue, animated: false)
        
        sliderLabel.text = "100.0 %"
        
        // set min-max to show 1%-100% of the waveform
        historySlider.minimumValue = 0.01
        historySlider.maximumValue = 1.0
        historySlider.setValue(slider.minimumValue, animated: false)
        
        historySliderLabel.text = "100.0 %"
        
        playButton = waveformView.playButton
        stopButton = waveformView.stopButton
        
        playButton.setTitle("Play", for: .normal)
        playButton.setTitleColor(.black, for: .normal)
        stopButton.setTitle("Stop", for: .normal)
        stopButton.setTitleColor(.black, for: .normal)
        
        view = waveformView
    }
}
