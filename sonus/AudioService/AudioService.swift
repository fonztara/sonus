//
//  AudioService.swift
//  sonus
//
//  Created by Alfonso Tarallo on 30/11/24.
//

import Foundation
import AVFoundation
import AppKit

class AudioService: ObservableObject {
    var player: AVAudioPlayer? = AVAudioPlayer()
    var recorder: AVAudioRecorder? = nil
    
    let folderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func setupRecorder() {
        var fileIndex = 1
        var audioFilePath: URL = folderPath.appendingPathComponent("audio\(fileIndex).m4a")

        while FileManager.default.fileExists(atPath: audioFilePath.path) {
            fileIndex += 1
            audioFilePath = folderPath.appendingPathComponent("audio\(fileIndex).m4a")
        }
        
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2,
            AVEncoderBitRateKey: 320000] as [String: Any]
        
        do {
            recorder = try AVAudioRecorder(url: audioFilePath, settings: settings)
            recorder?.prepareToRecord()
        } catch {
            recorder = nil
        }
    }

    func checkMicrophonePermission() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        var ok: Bool = false
        
        switch status {
        case .notDetermined:
            // Microphone access has not been requested yet
            print("Microphone access has not been requested. Requesting now.")
            AVCaptureDevice.requestAccess(for: .audio) { response in
                DispatchQueue.main.async {
                    if response {
                        print("Microphone access granted")
                        self.setupRecorder()
                        ok = true
                    } else {
                        print("Microphone access denied")
                    }
                }
            }
        case .restricted:
            print("Microphone access is restricted (e.g., parental controls).")
        case .denied:
            print("Microphone access denied.")
            // Inform the user to manually enable it in System Preferences
            self.showAccessDeniedAlert()
        case .authorized:
            print("Microphone access granted")
            self.setupRecorder()
            ok = true
        @unknown default:
            print("Unknown microphone permission status")
        }
        
        return ok
    }
    
    
    func showAccessDeniedAlert() {
        let alert = NSAlert()
        alert.messageText = "Microphone Access Denied"
        alert.informativeText = "Please enable microphone access in System Preferences > Privacy & Security > Microphone."
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }


    
    func playAudio(from url: URL, speed: Float = 1.0) {
        do {
            if FileManager.default.fileExists(atPath: url.path) {
            } else {
                print("File does not exist: \(url.path)")
                return
            }
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.volume = 1.0
            player?.enableRate = true
            player?.rate = speed
            player?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    func stopAudio() {
        if let playing = player?.isPlaying {
            if playing {
                player?.stop()
                player = AVAudioPlayer()
            }
        }
    }
}
