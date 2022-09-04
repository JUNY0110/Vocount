//
//  GoogleSpeechManager.swift
//  Vocount
//
//  Created by 지준용 on 2022/08/31.
//

import UIKit
import Foundation

class GoogleSpeechManager: NSObject {
    class func startRecording() {
        _ = AudioController.sharedInstance.prepare(specifiedSampleRate: 16000)
        SpeechRecognitionService.sharedInstance.sampleRate = 16000
        _ = AudioController.sharedInstance.start()
    }
    
    class func stopRecording() {
        _ = AudioController.sharedInstance.stop()
        SpeechRecognitionService.sharedInstance.stopStreaming()
    }
}
