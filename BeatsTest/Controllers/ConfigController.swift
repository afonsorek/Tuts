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
    
    @Published var config = Config()
    
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
    func forceScreenOrientation() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))
    }
    func lockOrientation() {
        forceScreenOrientation()
        config.orientationLock = true
    }
    func toggleOrientationLock() {
        config.orientationLock = !config.orientationLock
    }
    func unlockOrientation() {
        config.orientationLock = false
    }
}
