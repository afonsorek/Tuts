import Combine
import SwiftUI

class TimeController: ObservableObject {
    @Published var beats: Double = 0
    @Published var BPM: Double
    
    private var timer: AnyCancellable? // Usamos um AnyCancellable para armazenar o Timer

    init(beatsPerMinute: Double) {
        self.BPM = beatsPerMinute
        setBeatsPerMinute(beatsPerMinute)
    }
    
    func setBeatsPerMinute(_ newBPM: Double) {
        self.BPM = newBPM
        self.beats = 0
        
        // Cancela o timer existente se houver
        timer?.cancel()
        
        let interval = 60.0 / newBPM
        
        timer = Timer.publish(every: interval, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.beats += 1
            }
    }
}

