//
//  ConfigModel.swift
//  BeatsTest
//
//  Created by Rafa (Ruffles) on 13/11/23.
//

import Foundation

class Config : ObservableObject {
    @Published var orientationLock : Bool = false
    @Published var showBeats : Bool = true
    @Published var noteColors : Bool = true
    @Published var colorblindAccessibility : Bool = false
    @Published var metronomeActive : Bool = false
    @Published var loopCompass : Bool = true
    
    init(orientationLock: Bool, showBeats: Bool, noteColors: Bool, colorblindAccessibility: Bool, metronomeActive: Bool) {
        self.orientationLock = orientationLock
        self.showBeats = showBeats
        self.noteColors = noteColors
        self.colorblindAccessibility = colorblindAccessibility
        self.metronomeActive = metronomeActive
    }
}
