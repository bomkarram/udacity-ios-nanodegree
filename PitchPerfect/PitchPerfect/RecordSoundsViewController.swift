//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Abdulrahman Alamoudi on 11/10/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    enum Status: Int {case on = 0, off}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func startRecording(_ sender: Any) {
        changeRecordButton(status: .off)
        changeStopButton(status: .on)

        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord,mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    @IBAction func stopRecording(_ sender: Any) {
        changeRecordButton(status: .off)
        changeRecordButton(status: .on)

        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func setRecordLabel(text: String) {
        recordLabel.text = text
    }
    
    func changeRecordButton(status: Status) {
        switch status {
        case .on:
            recordButton.isEnabled = true
            setRecordLabel(text: "Tap to Record")
        case .off:
            recordButton.isEnabled = false
        }
    }
    
    func changeStopButton(status: Status) {
        switch status {
        case .on:
            stopButton.isEnabled = true
            setRecordLabel(text: "Recording in Progress")
        case .off:
            stopButton.isEnabled = false
        }
    }
}

