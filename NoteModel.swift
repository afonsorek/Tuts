//
//  NoteModel.swift
//  BeatsTest
//
//  Created by Afonso Rekbaim on 30/10/23.
//

import Foundation
import SwiftUI

struct Note: Hashable, Comparable{
    static func < (lhs: Note, rhs: Note) -> Bool {
        return lhs.duration < rhs.duration
    }
    
    let name: String
    let duration: Double
    var color: Color
    var pause: Bool
    var imageName : String {
        "\(name)-Nota"
    }
    
    init(name: String, duration: Double, color: Color = .white, pause: Bool = false) {
        self.name = name
        self.duration = duration
        self.color = color
        self.pause = pause
    }
    
    // Public functions
    func togglePause() -> Note {
        return Note(name: name, duration: duration, color: color, pause: !pause)
    }
}
