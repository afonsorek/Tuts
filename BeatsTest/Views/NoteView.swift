//
//  NoteView.swift
//  BeatsTest
//
//  Created by Afonso Rekbaim on 09/11/23.
//

import SwiftUI

struct NoteView: View {
    let nota: Note
    
    init(nota: Note) {
        self.nota = nota
    }
    
    var body: some View {
        ZStack{
            Rectangle()
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white, lineWidth: 2))
                .cornerRadius(20)
                .foregroundStyle(getNoteColor(name: nota.name))
            VStack(spacing: 13){
                //ANIMATION BRANCH
                ZStack{
                    Rectangle()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                        .frame(height: 1)
                    HStack{
                        CircleView(duration: nota.duration)
                        Spacer()
                    }
                }
                //----------------
                Rectangle()
                    .frame(height: 1)
                    .padding(.horizontal, 10)
                Image("\(nota.name)")
                    .colorInvert()
                    .scaleEffect(0.7)
                    .frame(height: 30)
                    .padding(.top, 10)
            }
        }
    }
}

#Preview {
    NoteView(nota: Note(name: "a", duration: 1.0))
}
