//
//  ConfigController.swift
//  BeatsTest
//
//  Created by Rafa (Ruffles) on 13/11/23.
//

import Foundation
import SwiftUI

class ConfigController : ObservableObject {
    static var shared: ConfigController = {
        let instance = ConfigController()
        return instance
    }()
    
    @Published var config = Config(orientationLock: false, showBeats: true, noteColors: true, colorblindAccessibility: false, metronomeActive: false)
    
    //GAMBIARRA FUNCIONAL
    @Published var showBeats = true
    @Published var noteColors = true
    @Published var colorblindAccessibility = false
    @Published var metronomeActive = false
    //---------------------------------------------
    
    var orientationBinding : Binding<Bool> = Binding(get: {false}, set: {_ in })
    var showBeatsBinding : Binding<Bool> = Binding(get: {false}, set: {_ in })
    var noteColorsBinding : Binding<Bool> = Binding(get: {false}, set: {_ in })
    var colorblindAccessibilityBinding : Binding<Bool> = Binding(get: {false}, set: {_ in })
    var metronomeActiveBinding : Binding<Bool> = Binding(get: {false}, set: {_ in })
    
    // Event functions
    init() {
        orientationBinding = Binding(
            get: {
                return self.config.orientationLock
            },
            set: { [self] in
                if $0 {
                    lockOrientation()
                }
                else {
                    unlockOrientation()
                }
            }
        )
        showBeatsBinding = Binding(get: {self.config.showBeats}, set: {self.config.showBeats = $0})
        noteColorsBinding = Binding(get: {self.config.noteColors}, set: {self.config.noteColors = $0})
        colorblindAccessibilityBinding = Binding(get: {self.config.colorblindAccessibility}, set: {self.config.colorblindAccessibility = $0})
        metronomeActiveBinding = Binding(get: {self.config.metronomeActive}, set: {self.config.metronomeActive = $0})
    }
    
    // Public functions
    func lockOrientation() {
        config.orientationLock = true
        RotationController.forceScreenOrientation(orientation: .landscape)
    }
    func toggleLoopCompass() {
        config.loopCompass.toggle()
        objectWillChange.send()
    }
    func toggleOrientationLock() {
        if config.orientationLock {
            unlockOrientation()
        }
        else {
            lockOrientation()
        }
        
        objectWillChange.send()
    }
    func unlockOrientation() {
        config.orientationLock = false
        if (RotationController.isEditMode() || !RotationController.isValidOrientation()) {
            RotationController.forceScreenOrientation(orientation: .portrait)
            TimeController.shared.stopTimer()
        }
    }
}
