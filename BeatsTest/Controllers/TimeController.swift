import Combine
import SwiftUI

class TimeController: ObservableObject {
    static var shared: TimeController = {
        let instance = TimeController()
        return instance
    }()
    
    @Published var beats: Double = 0
    @Published var BPM: Int = 60
    @Published var isPlaying = false
    var timerListeners: [(Double) -> Void] = []
    var bpmBinding : Binding<Int> = Binding(get: {0}, set: {_ in})
    
    private var timer: AnyCancellable? // Usamos um AnyCancellable para armazenar o Timer
    private let beatMinInterval : Double = 1.0/32.0
    
    // Constructor
    private init() {
        bpmBinding = Binding(get: { self.BPM }, set: { self.setBeatsPerMinute($0) })
    }
    
    // Public functions
    
    func setBeatsPerMinute(_ newBPM: Int) {
        BPM = newBPM
        resetTimer()
    }
    
    func initTimer() {
        let interval = 60.0 / (Double(BPM)*32.0)
        beats = -beatMinInterval
        
        timer = Timer.publish(every: interval, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                beats += beatMinInterval
                for listener in timerListeners {
                    listener(beats)
                }
            }
        
        isPlaying = true
    }
    
    func stopTimer() {
        timer?.cancel()
        isPlaying = false
    }
    
    func resetTimer() {
        let wasPlaying = isPlaying
        stopTimer()
        
        if wasPlaying {
            initTimer()
        }
    }
    
    func toggleTimer() {
        if isPlaying {
            stopTimer()
        }
        else {
            initTimer()
        }
    }
}

