//
//  AudioAnalyzer.swift
//  Harmonic Flight
//
//  Created by Sam Hepditch on 2024-03-14.
//
import Foundation
import AudioKit
import AVFoundation

protocol AudioAnalyzerDelegate {
    func microphoneTracker(trackedFrequency: Double, trackedAmplitude: Double)
}

class AudioAnalyzer {
    
    var delegate: AudioAnalyzerDelegate?
    var onUpdate: ((Double, Double) -> Void)?
    
    private var microphoneTracker: AKMicrophoneTracker?
    
    init() {
        configureAudioSession()
        microphoneTracker = AKMicrophoneTracker()
    }
    
    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setPreferredSampleRate(audioSession.sampleRate)
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .defaultToSpeaker)
            try audioSession.setActive(true)
            AKSettings.sampleRate = audioSession.sampleRate
            AKSettings.channelCount = UInt32(audioSession.inputNumberOfChannels)
        } catch {
            print("Failed to set audio session properties. Error: \(error)")
        }
    }
    
    func start() {
        microphoneTracker?.start()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateTracking()
        }
    }
    
    func stop() {
        microphoneTracker?.stop()
    }
    
    private func updateTracking() {
        guard let tracker = microphoneTracker else { return }
        let frequency = tracker.frequency
        let amplitude = tracker.amplitude
        if amplitude > 0.05 {
            onUpdate?(frequency, amplitude)
        }
    }
    
}
