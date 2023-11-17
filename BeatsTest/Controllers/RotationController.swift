//
//  RotationController.swift
//  BeatsTest
//
//  Created by Rafa (Ruffles) on 16/11/23.
//

import Foundation
import SwiftUI

class RotationController : ObservableObject {
    static var shared: RotationController = {
        let instance = RotationController()
        return instance
    }()
    
    @Published var screenRect : CGRect
    
    private init() {
        screenRect =  RotationController.correctedScreenRect()
    }
    
    func updateScreenRect() {
        screenRect =  RotationController.correctedScreenRect()
    }
    
    static func correctedScreenRect() -> CGRect {
        let originalRect = UIScreen.main.bounds
        
        if !(originalRect.width > originalRect.height) {
            return CGRect(x: originalRect.minX, y: originalRect.minY, width: originalRect.height, height: originalRect.width)
        }
        else {
            return originalRect
        }
    }
    
    static func forceScreenOrientation(orientation : UIInterfaceOrientationMask = .landscape) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
    }
    
    static func isShowMode(orientation : UIDeviceOrientation = UIDevice.current.orientation) -> Bool {
        return ConfigController.shared.config.orientationLock || orientation.isLandscape
    }
    
    static func isEditMode(orientation : UIDeviceOrientation = UIDevice.current.orientation) -> Bool {
        return !isShowMode(orientation: orientation)
    }
    
    static func isValidOrientation(orientation : UIDeviceOrientation = UIDevice.current.orientation) -> Bool {
        return !(orientation.isFlat || orientation.rawValue == 2)
    }
}
