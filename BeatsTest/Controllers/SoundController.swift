import Foundation
import AVFoundation
import SwiftUI

class SoundController : NSObject, AVAudioPlayerDelegate {
    private var audioPlayerPool : [AVAudioPlayer] = []
    private var busyAudioPlayers : [AVAudioPlayer] = []
    let startingAudioPlayers : Int = 4
    
    override init() {
        super.init()
        for _ in 1...startingAudioPlayers {
            _ = getAudioPlayer(sound: .beat)
        }
    }
    
    private func getAudioPlayer(sound: Sound) -> AVAudioPlayer? {
        if !audioPlayerPool.isEmpty {
            return audioPlayerPool.removeFirst()
        }
        
        guard let url = Bundle.main.url(
            forResource: sound.rawValue,
            withExtension: ".wav"
        ) else {
            print("Fail to get url for \(sound)")
            return nil
        }
        
        var audioPlayer: AVAudioPlayer?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
//            audioPlayer?.volume = 100.0
//            audioPlayer?.pan = 5.0
            return audioPlayer
        } catch {
            print("Fail to load \(sound)")
            return nil
        }
    }
    
    // func playLoop() esteve aqui, te amo Afonso
    
    func playBeat() {
        playSound(sound: .beat)
    }
    
    func playSound(sound: Sound) {
        guard let player = getAudioPlayer(sound: sound) else {
            return
        }
        player.play()
        player.delegate = self
        busyAudioPlayers.append(player)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        busyAudioPlayers.removeAll(where: {$0 == player})
        audioPlayerPool.append(player)
    }
    
    enum Sound: String, CaseIterable {
        case beat
    }
}
