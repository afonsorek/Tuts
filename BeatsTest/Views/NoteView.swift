//
//  NoteView.swift
//  BeatsTest
//
//  Created by Rafa (Ruffles) on 09/11/23.
//

import SwiftUI

struct NoteView: View {
    var nota : Note
    
    var body: some View {
        ZStack{
            Rectangle()
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white, lineWidth: 2))
                .cornerRadius(20)
                .foregroundStyle(nota.color)
            VStack(spacing: 13){
                Circle()
                    .frame(width: 30)
                    .foregroundStyle(.black)
                Rectangle()
                    .frame(height: 1)
                    .padding(.horizontal, 10)
                Image(nota.name.lowercased())
                    .colorInvert()
                    .scaleEffect(0.7)
                    .frame(height: 30)
                    .padding(.top, 10)
            }
        }
    }
}

#Preview {
    VStack {
        ForEach(NotesData.notes, id: \.self) { nota in
            NoteView(nota: nota)
        }
    }
}
