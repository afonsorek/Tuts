//
//  CompassController.swift
//  BeatsTest
//
//  Created by Rafa (Ruffles) on 07/11/23.
//

import Foundation
import SwiftUI

class CompassController : ObservableObject {
    private let time = TimeController.shared
    private let soundController = SoundController()
    let pulseDurationsValues = [1, 2, 4, 8, 16, 32]
    
    @Published var compass = Compass(pulseCount: 4, pulseDuration: 4, notes: [])
    @Published var currentNoteIndex = -1
    var pulseCountBinding : Binding<Int> = Binding ( get: {-1}, set: {_ in })
    var pulseDurationBinding : Binding<Int> = Binding ( get: {-1}, set: {_ in })
    
    init() {
        time.timerListeners.append({beat in
            if beat < 0 {
                return
            }
            
            let truncatedBeat = beat.truncatingRemainder(dividingBy: Double(self.compass.pulseCount))
            for i in 0..<self.compass.noteBeats.count {
                if truncatedBeat/Double(self.compass.pulseDuration) == self.compass.noteBeats[i] {
                    self.soundController.playBeat()
                    
                    if self.currentNoteIndex != i {
                        self.currentNoteIndex = i
                    }
                }
            }
        })
        pulseCountBinding = Binding(
            get: {self.compass.pulseCount},
            set: {
                self.compass.pulseCount = $0
                TimeController.shared.resetTimer()
                self.limitNotes()
            }
        )
        pulseDurationBinding = Binding(
            get: {self.compass.pulseDuration},
            set: {
                self.compass.pulseDuration = $0
                TimeController.shared.resetTimer()
                self.limitNotes()
            }
        )
    }
    
    // Public functions
    func addNote(note: Note) -> Bool{
        if note.duration <= compass.remainingSize{
            compass.notes.append(note)
            objectWillChange.send()
            return true
        }else{
            print("Não cabeu")
            return false
        }
    }
    
    func removeNote(){
        if !compass.notes.isEmpty{
            compass.notes.removeLast()
            objectWillChange.send()
        }
    }
    
    func removeAllNotes(){
        compass.notes.removeAll()
        objectWillChange.send()
    }
    
    // Private functions
    private func limitNotes() {
        while compass.remainingSize < 0 {
            removeNote()
        }
        objectWillChange.send()
    }
}
