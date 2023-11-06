import Combine
import SwiftUI

class TimeController: ObservableObject {
    static var shared: TimeController = {
        let instance = TimeController()
        return instance
    }()
    
    @Published var beats: Double = 0
    @Published var BPM: Double = 60
//    var lastBeat: Double = 0
    var soundController = SoundController()
    
    private var timer: AnyCancellable? // Usamos um AnyCancellable para armazenar o Timer

    private init(beatsPerMinute: Double = 60) {
        setBeatsPerMinute(beatsPerMinute)
    }
    
    func setBeatsPerMinute(_ newBPM: Double) {
        BPM = newBPM
        beats = 0
//        lastBeat = 0
        
        RepublishTimer()
    }
    
    func RepublishTimer(){
        timer?.cancel()
        
        let interval = 60.0 / (BPM*32.0)
        
        timer = Timer.publish(every: interval, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                beats += 1.0/32.0
//                playBeat()
            }
    }
    
//    func playBeat() {
//        let flooredBeat = floor(beats)
//        if (flooredBeat > lastBeat) {
//            soundController.playBeat()
//            lastBeat = flooredBeat
//        }
//    }
}

