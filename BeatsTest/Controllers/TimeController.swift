import Combine
import SwiftUI

class TimeController: ObservableObject {
    static var shared: TimeController = {
        let instance = TimeController()
        return instance
    }()
    
    @Published var beats: Double = 0
    @Published var BPM: Int = 60
    var timerListeners: [(Double) -> Void] = []
    var soundController = SoundController()
    
    var BPMBinding : Binding<Int> = Binding ( get: {-1}, set: {_ in })
    
    private var timer: AnyCancellable? // Usamos um AnyCancellable para armazenar o Timer

    private init() {
        initTimer()
        BPMBinding = Binding(
            get: {self.BPM},
            set: {
                self.BPM = $0
            }
        )
    }
    
    func setBeatsPerMinute(_ newBPM: Int) {
        BPM = newBPM
        beats = 0
    }
    
    func initTimer() {
        let interval = 60.0 / (Double(BPM)*32.0)
        
        timer = Timer.publish(every: interval, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                beats += 1.0/32.0
                for listener in timerListeners {
                    listener(beats)
                }
            }
    }
    
    func stopTimer() {
        timer?.cancel()
    }
    
    func resetTimer() {
        stopTimer()
        initTimer()
    }
}

