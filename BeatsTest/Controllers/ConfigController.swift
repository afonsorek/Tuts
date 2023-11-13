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
    }
    
    // Public functions
    func forceScreenOrientation() {
//        let value = UIInterfaceOrientation.landscapeRight.rawValue
//        UIDevice.current.setValue(value, forKey: "orientation")
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
