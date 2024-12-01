//
//  AudioService.swift
//  sonus
//
//  Created by Alfonso Tarallo on 30/11/24.
//

import Foundation
import AVFoundation

class AudioService: ObservableObject {
    var player: AVAudioPlayer? = AVAudioPlayer()
    
    func playAudio(from url: URL) {
        do {
            if FileManager.default.fileExists(atPath: url.path) {
            } else {
                print("File does not exist: \(url.path)")
                return
            }
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.volume = 1.0
            player?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
}
