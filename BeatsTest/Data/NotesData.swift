//
//  NotesData.swift
//  BeatsTest
//
//  Created by Rafa (Ruffles) on 07/11/23.
//

import Foundation

final class NotesData {
    static let notes: [Note] = [
        Note(name: "Semibreve", duration: 1),
        Note(name: "Minima", duration: 1/2),
        Note(name: "Seminima", duration: 1/4),
        Note(name: "Colcheia", duration: 1/8),
        Note(name: "Semicolcheia", duration: 1/16),
        Note(name: "Fusa", duration: 1/32),
        Note(name: "Semifusa", duration: 1/64),
        Note(name: "Quartifusa", duration: 1/128)
    ]
}
