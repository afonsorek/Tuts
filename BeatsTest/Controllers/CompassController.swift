//
//  CompassController.swift
//  BeatsTest
//
//  Created by Rafa (Ruffles) on 07/11/23.
//

import Foundation
import SwiftUI

class CompassController : ObservableObject {
    private let configController = ConfigController.shared
    private let time = TimeController.shared
    private let soundController = SoundController()
    
    @Published var compass = Compass(pulseCount: 4, pulseDuration: 4, notes: [])
    @Published var currentNoteIndex = -1
    var currentNoteIndexListeners : [(Int) -> Void] = []
    var looped : Bool = false
    var pulseCountBinding : Binding<Int> = Binding ( get: {-1}, set: {_ in })
    var pulseDurationBinding : Binding<Int> = Binding ( get: {-1}, set: {_ in })
    
    init(compass : Compass  = Compass(pulseCount: 4, pulseDuration: 4, notes: [])) {
        self.compass = compass
        time.timerListeners.append({beat in
            if beat < 0 {
                self.looped = false
                return
            }
            
            let truncatedBeat = beat.truncatingRemainder(dividingBy: Double(self.compass.pulseCount))
            if truncatedBeat == 0 {
                self.setCurrentNoteIndex(value: -1)
                if (self.looped && !self.configController.config.loopCompass) {
                    self.time.stopTimer()
                }
                else {
                    self.looped = true
                }
            }
            
            for i in 0..<self.compass.noteBeats.count {
                if self.time.isPlaying && truncatedBeat/Double(self.compass.pulseDuration) == self.compass.noteBeats[i] {
                    if self.currentNoteIndex != i {
                        self.setCurrentNoteIndex(value: i)
                    }
                    
                    if !self.compass.notes[i].pause {
                        let generator = UIImpactFeedbackGenerator(style: .heavy)
                        generator.impactOccurred()
                        self.soundController.playBeat()
                    }else{
                        let generator = UIImpactFeedbackGenerator(style: .soft)
                        generator.impactOccurred()
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
    func addNote(note: Note, index: Int = -1) -> Bool{
        if note.duration <= compass.remainingSize{
            if index <= -1 {
                objectWillChange.send()
                compass.notes.append(note)
                objectWillChange.send()
            }
            else {
                objectWillChange.send()
                compass.notes.insert(note, at: index)
                objectWillChange.send()
            }
            objectWillChange.send()
            return true
        }else{
            print("Não cabeu")
            objectWillChange.send()
            return false
        }
    }
    
    func setNotePause(noteIndex: Int, pause: Bool) {
        let note = compass.notes[noteIndex]
        removeNote(index: noteIndex)
        _ = addNote(note: note.togglePause(), index: noteIndex)
    }
    
    func removeNote(index: Int = -1){
        if !compass.notes.isEmpty{
            if (index <= -1) {
                compass.notes.removeLast()
            }
            else if index < compass.notes.count {
                compass.notes.remove(at: index)
            }
            objectWillChange.send()
        }
    }
    
    func removeAllNotes(){
        compass.notes.removeAll()
        objectWillChange.send()
    }
    
    func random(){
        removeAllNotes()
        
        while compass.remainingSize != 0{
            let randomInt = Int.random(in: 0..<5)
            _ = addNote(note: NotesData.notes[randomInt])
        }
        
        objectWillChange.send()
    }
    
    // Private functions
    private func limitNotes() {
        while compass.remainingSize < 0 {
            removeNote()
        }
        objectWillChange.send()
    }
    
    private func setCurrentNoteIndex(value : Int) {
        currentNoteIndex = value
        for listener in currentNoteIndexListeners {
            listener(currentNoteIndex)
        }
    }
}
