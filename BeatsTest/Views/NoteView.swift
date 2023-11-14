//
//  NoteView.swift
//  BeatsTest
//  8=========================================================================================================D
//  Created by Afonso Rekbaim and Rafa (Ruffles) 09/11/23.
//

import SwiftUI

struct NoteView: View {
    let nota: Note
    let screenRect = ScreenSizeUtil.getScreenRect()
    @State var animationProgress = 0.0
    @State var showcase : Bool
    
    var body: some View {
        ZStack{
            Rectangle()
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white, lineWidth: showcase ? 6 : 2))
                .cornerRadius(20)
                .foregroundColor(nota.color)
            VStack (spacing: 13) {
                ZStack{
                    if !showcase{
                        Rectangle()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                            .frame(height: 1)
                    }
                    HStack{
                        if showcase{
                            Circle()
                                .frame(width: 31)
                                .foregroundStyle(.black)
                        }else{
                            HStack{
                                Circle()
                                    .frame(width: 10)
                                    .foregroundColor(.black)
                                    .offset(x: animationProgress)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
                Rectangle()
                    .frame(height: 1)
                    .padding(.horizontal, 10)
                    .foregroundStyle(.white)
                Image(nota.name.lowercased())
                    .colorInvert()
                    .scaleEffect(0.7)
                    .frame(height: 30)
                    .padding(.top, 10)
            }.onChange(of: nota.act) { oldValue, newValue in
                startMotion()
            }
        }
    }
    
    func startMotion(){
        animationProgress = screenRect.width*0.05*(4.0*nota.duration)/4.0
        // Start the animation when the view appears
        withAnimation(Animation.linear(duration: 4*nota.duration)) {
            animationProgress = screenRect.width*0.7*(Double(4) * nota.duration)/Double(4)
        }
    }
}

#Preview {
    VStack {
        ForEach(NotesData.notes, id: \.self) { nota in
            NoteView(nota: nota, showcase: false)
        }
    }
}
