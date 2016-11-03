//
//  ViewController.swift
//  Rippl
//
//  Created by Jean-Étienne Parrot on 13/10/2016.
//  Copyright © 2016 Jean-Étienne. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var ripplView: Rippl!

    @IBOutlet var imageView: UIImageView!

    var soundRecorder: SoundRecorder?

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try soundRecorder = SoundRecorder.init(withDelegate: self)
            soundRecorder?.requestRecordPermission()
        } catch {
            print("❌ Could not create the Sound Recorder: \(error)")
        }
    }

    @IBAction func recordButtonDidTouchUpInside(_ sender: AnyObject, forEvent event: UIEvent) {
        if let soundRecorder = soundRecorder {
            do {
                try soundRecorder.startRecording()
            } catch SoundRecorderError.RecordPermissionNotGranted {
                print("❌ Permission to record not granted")
            } catch {
                print("❌ Can't record: Unknown Error")
            }
        }
    }
    
    @IBAction func animateButtonDidTouchUpInside(_ sender: AnyObject, forEvent event: UIEvent) {
        ripplView.animateImpact(strength: 2.5, duration: 1.5)
    }

}

extension ViewController: SoundRecorderDelegate {

    func soundRecorder(_ soundRecorder: SoundRecorder, didUpdateAveragePower averagePower: Float, peakPower: Float) {

        // Gaussian filter
        let lowerBound: Float = -40.0
        let upperBound: Float = -5.0

        var boundedAveragePower = min(averagePower, upperBound)
        boundedAveragePower = max(averagePower, lowerBound)

        let normalisedAveragePower = ((boundedAveragePower + abs(lowerBound)) / abs(upperBound - lowerBound))

        let gain: Float = 2.0
        let minimumOffset: Float = 1.0

        ripplView.animateGain(value: CGFloat(normalisedAveragePower * gain + minimumOffset))
    }

    func soundRecorderDidFinishRecording(_ soundRecorder: SoundRecorder) {
        print("🎙 Recording finished")
    }

}
