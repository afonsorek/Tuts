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
    var imageName : String {
        "\(name)-Nota"
    }
    
    var act = false
    
    init(name: String, duration: Double, color: Color = .white) {
        self.name = name
        self.duration = duration
        self.color = color
    }
    
//    mutating func changeState(){
//        self.act.toggle()
//        withAnimation(.linear(duration: 1)){
//            self.color = .white.opacity(0)
//            withAnimation(.linear(duration: 1)){
//                self.color = .white.opacity(1)
//            }
//        }
//    }
}
