//
//  MusicManager.swift
//  codableApp
//
//  Created by or paztal on 03/07/2019.
//  Copyright © 2019 Or paz tal. All rights reserved.
//

import UIKit
import AVFoundation

class MusicManager {

    static let shared = MusicManager()
    var audioPlayer: AVAudioPlayer?
    var isMusicPlaying: Bool = false
    
    func setUpMusic() {
        if isMusicPlaying {
            stopBackgroundMusic()
        } else {
            startBackgroundMusic()
        }
    }
    
    func startBackgroundMusic() {
        if let bundle = Bundle.main.path(forResource: "Queen", ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                
                isMusicPlaying = true
            } catch {
                print(error)
            }
        }
    }
    
    func stopBackgroundMusic() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.stop()
        isMusicPlaying = false
    }
}
