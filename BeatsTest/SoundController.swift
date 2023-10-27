import Foundation
import AVFoundation
import SwiftUI

class SoundManager {
    private var soundDict: [Sound:AVAudioPlayer?] = [:]
    @State var check = 0.0
    @State var check2 = false
    
    init() {
        for sound in Sound.allCases {
            soundDict[sound] = getAudioPlayer(sound: sound)
        }
    }
    
    
    private func getAudioPlayer(sound: Sound) -> AVAudioPlayer? {
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
            return audioPlayer
        } catch {
            print("Fail to load \(sound)")
            return nil
        }
    }
    
    func playLoop(sound: Sound, split: String, tempo: String, check: Double) {
        let compass = tempo.split(separator: "/")
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        
        if check == Double(compass[1]){
            print("""
                
                Encerrado no Compasso da nota: \(check)
                
                """)
            
            print("""
                ----------------------------------
                Encerrado no Compasso Geral: \(check.rounded(.down))
                ----------------------------------
                """)
            
            self.stopAll()
            return
        }else if check != 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4*Double(split)!){
                audioPlayer.play()

                print("""
                    
                    Compasso da nota: \(check)
                    
                    """)
                
                print("""
                    ----------------------------------
                    Compasso Geral: \(check.rounded(.down))
                    ----------------------------------
                    """)

                self.playLoop(sound: sound, split: split, tempo: tempo, check: check+Double(split)!)
            }
        }else{
            audioPlayer.play()

            print("""
                
                Compasso da nota: \(check)
                
                """)
            
            print("""
                ----------------------------------
                Compasso Geral: \(check.rounded(.down))
                ----------------------------------
                """)
            
            self.check2.toggle()
            self.playLoop(sound: sound, split: split, tempo: tempo, check: check+Double(split)!)
        }
    }
    
    func stop(sound: Sound) {
        guard let audioPlayer = soundDict[sound, default: nil] else { return }
        audioPlayer.currentTime = 0
        audioPlayer.pause()
    }
    
    func stopAll() {
        for name in soundDict.values{
            name?.stop()
        }
    }
    
    enum Sound: String, CaseIterable {
        case beat
    }
}
