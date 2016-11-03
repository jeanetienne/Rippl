//
//  VoiceRecorder.swift
//  Rippl
//
//  Created by Jean-Étienne on 20/10/16.
//  Copyright © 2016 Jean-Étienne. All rights reserved.
//

import Foundation
import AVFoundation

protocol SoundRecorderDelegate: class {

    func soundRecorder(_ soundRecorder: SoundRecorder, didUpdateAveragePower averagePower: Float, peakPower: Float)

    func soundRecorderDidFinishRecording(_ soundRecorder: SoundRecorder)

}

enum SoundRecorderError: Error {

    case RecordPermissionNotGranted

}

class SoundRecorder: NSObject, AVAudioRecorderDelegate {

    let delegate: SoundRecorderDelegate

    private let soundRecordingDuration: TimeInterval = 10

    private let soundRecordingMeteringInterval: TimeInterval = 0.1
    
    private let audioSession = AVAudioSession.sharedInstance()

    private let audioRecorder: AVAudioRecorder

    private var meteringTimer: Timer?

    init(withDelegate delegate: SoundRecorderDelegate) throws {

        // Delegate
        self.delegate = delegate

        // Audio Session
        try self.audioSession.setCategory(AVAudioSessionCategoryRecord)

        // Audio Recorder
//        let recorderSettings: [String: Any] = [AVFormatIDKey:               NSNumber(value: kAudioFormatLinearPCM),
//                                               AVSampleRateKey:             NSNumber(value: 8000.0),
//                                               AVNumberOfChannelsKey:       NSNumber(value: 1),
//                                               AVEncoderAudioQualityKey:    AVAudioQuality.max
//        ]
        let fileURL = SoundRecorder.generateSoundRecordingFileURL()
        try self.audioRecorder = AVAudioRecorder.init(url: fileURL,
                                                      settings: [:])

        super.init()

        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
    }

    func requestRecordPermission() {
        audioSession.requestRecordPermission { (Bool) in
        }
    }

    func startRecording() throws {
        if audioSession.recordPermission() == .granted {
            if !audioRecorder.isRecording {
                try audioSession.setActive(true)
                let recordingDidWork = audioRecorder.record(forDuration: soundRecordingDuration)
                if recordingDidWork {
                    self.prepareMeteringTimer()
                }
            }
        } else {
            throw SoundRecorderError.RecordPermissionNotGranted
        }
    }

    // MARK: - AVAudioRecorderDelegate
    internal func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if recorder == audioRecorder {
            delegate.soundRecorderDidFinishRecording(self)
            if let meteringTimer = self.meteringTimer {
                meteringTimer.invalidate()
            }
        }
    }

    // MARK: - Private helpers
    private static func generateSoundRecordingFileURL() -> URL {
        var documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        documentsURL.appendPathComponent("sound_recording.wav")

        return documentsURL
    }

    private func prepareMeteringTimer() {
        meteringTimer = Timer.scheduledTimer(
            withTimeInterval: soundRecordingMeteringInterval,
            repeats: true,
            block: { (Timer) in
                if self.audioRecorder.isRecording {
                    self.audioRecorder.updateMeters()
                    self.delegate.soundRecorder(self,
                                                didUpdateAveragePower: self.audioRecorder.averagePower(forChannel: 0),
                                                peakPower: self.audioRecorder.peakPower(forChannel: 0))
                }
        })
   }

}
