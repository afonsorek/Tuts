//
//  BarView.swift
//  BeatsTest
//
//  Created by Afonso Rekbaim on 10/11/23.
//

import SwiftUI

struct BarView: View {
    @ObservedObject var compassController : CompassController
    @ObservedObject var configController = ConfigController.shared
    @ObservedObject var rotationController = RotationController.shared
    let bigPadding : Double = 10
    let smallPadding : Double = 5
    
    func check() -> Bool{
        return compassController.compass.pulseCount > 1
    }
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundStyle(.white)
                .opacity(0.1)
            HStack(alignment: .center, spacing: 0){
                Spacer()
                ForEach((2...(check() ? compassController.compass.pulseCount : 2)), id: \.self){ _ in
                    Spacer()
                    Rectangle()
                        .stroke(Color(red: 0.61, green: 0.61, blue: 0.61), style: StrokeStyle(lineWidth: 1, dash: [3]))
                        .frame(width: 1)
                        .frame(maxHeight: .infinity)
                    Spacer()
                }
                Spacer()
            }
            HStack(alignment: .center, spacing: 0){
                let notes = compassController.compass.notes
                ForEach(0..<notes.count, id: \.self) { i in
                    NoteView(nota: notes[i], showcase: false, compassController: compassController, actIndex: i)
                        .padding(.leading, leadingNotePadding(notes: notes, maxIndex: i))
                        .padding(.trailing, trailingNotePadding(notes: notes, maxIndex: i))
                        .frame(width: noteWidth(nota: notes[i]), height: noteHeight())
//                        if spacerCheck(notes: notes, maxIndex: i) {
//                            Spacer()
//                                .background(.red)
//                                .padding(.leading, 20)
//                        }
                }
                .padding(.horizontal, 0)
                Spacer(minLength: 0)
            }.padding(.horizontal, 0)
        }
        .frame(width: barWidth(), height: barHeight())
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .circular))
    }
    
    func barWidth() -> Double {
        return rotationController.screenRect.width*0.8
    }
    func barHeight() -> Double {
        return rotationController.screenRect.height*0.5
    }
    func noteWidth(nota: Note) -> Double {
        let pulseCount = Double(compassController.compass.pulseCount)
        let pulseDuration = Double(compassController.compass.pulseDuration)
        return barWidth()*nota.duration*pulseDuration/pulseCount
    }
    func noteHeight() -> Double {
        return barHeight()*0.8
    }
    func sizeCount(notes:[Note], maxIndex: Int) -> Double {
        var sizeCount : Double = 0
        for i in 0...maxIndex {
            sizeCount += notes[i].duration
        }
        return sizeCount
    }
    func spacerCheck(notes: [Note], maxIndex: Int) -> Bool {
        var sizeCount : Double = 0
        for i in 0...maxIndex {
            sizeCount += notes[i].duration
        }
        
        let pulseCount = Double(compassController.compass.pulseCount)
        let remainderIsZero = sizeCount.truncatingRemainder(dividingBy:1.0/pulseCount).isZero
        
        return remainderIsZero && sizeCount != 0.0 || notes[maxIndex].duration >= 0.25
    }
    func leadingNotePadding(notes:[Note], maxIndex: Int) -> Double {
        if maxIndex == 0 {
            return bigPadding
        }
        
        return notePadding(notes: notes, maxIndex: maxIndex-1)
    }
    func trailingNotePadding(notes:[Note], maxIndex: Int) -> Double {
        if maxIndex == notes.count-1 {
            return bigPadding
        }
        
        return notePadding(notes: notes, maxIndex: maxIndex)
    }
    func notePadding(notes:[Note], maxIndex: Int) -> Double {
        let sizeCount = sizeCount(notes: notes, maxIndex: maxIndex)
        let pulseCount = Double(compassController.compass.pulseCount)
        let remainderIsZero = sizeCount.truncatingRemainder(dividingBy:1.0/pulseCount).isZero
        
        return remainderIsZero ? bigPadding : smallPadding
    }
}

#Preview {
    BarView(compassController: CompassController())
}
