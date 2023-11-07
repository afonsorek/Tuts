//
//  NoteModel.swift
//  BeatsTest
//
//  Created by Afonso Rekbaim on 30/10/23.
//

import Foundation

struct Note: Hashable, Comparable{
    static func < (lhs: Note, rhs: Note) -> Bool {
        return lhs.duration < rhs.duration
    }
    
    let name: String
    let duration: Double
    var imageName : String {
        "\(name)-Nota"
    }
    
    init(name: String, duration: Double) {
        self.name = name
        self.duration = duration
    }
}
