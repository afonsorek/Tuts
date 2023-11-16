//
//  ScreenSizeUtil.swift
//  BeatsTest
//
//  Created by Rafa (Ruffles) on 14/11/23.
//

import Foundation
import SwiftUI

class ScreenSizeUtil {
    static func getScreenRect() -> CGRect {
        let originalRect = UIScreen.main.bounds
        
        // Pega as dimensões normais se a tela não estiver travada
        if (!ConfigController.shared.config.orientationLock) {
            return originalRect
        }
        
        if originalRect.width > originalRect.height {
            return CGRect(x: originalRect.minX, y: originalRect.minY, width: originalRect.height, height: originalRect.width)
        }
        else {
            return originalRect
        }
    }
}
