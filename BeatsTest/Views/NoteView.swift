//
//  NoteView.swift
//  BeatsTest
//  8=========================================================================================================D
//  Created by Afonso Rekbaim and Rafa (Ruffles) 09/11/23.
//

import SwiftUI

struct NoteView: View {
    @ObservedObject var compassController : CompassController
    @ObservedObject var configController = ConfigController.shared
    
    let orientation = UIDevice.current.orientation
    let nota: Note
    let screenRect = ScreenSizeUtil.getScreenRect()
    let showcase : Bool
    let actIndex : Int
    
    init(nota: Note, showcase: Bool, compassController: CompassController? = nil, actIndex: Int = -1) {
        self.nota = nota
        self.showcase = showcase
        self.compassController = compassController ?? CompassController()
        self.actIndex = actIndex
    }
    
    @State var animationProgress = 0.0
    @State var lightedUp = false
    @State var volta = false
    
    var body: some View {
        ZStack{
            Rectangle()
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white, lineWidth: showcase ? 6 : 2))
                .cornerRadius(20)
                .foregroundColor(noteColor())
            VStack (spacing: 13) {
                ZStack{
                    if showBeatLine(){
                        Rectangle()
                            .stroke(LinearGradient(colors: [.black.opacity(1), .black.opacity(0)], startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 1, dash: [3]))
                            .frame(height: 1)
                            .frame(width: noteWidth(screenRect: screenRect, nota: nota))
                        HStack{
                            ForEach (1...Int(Double(compassController.compass.pulseDuration)*nota.duration), id: \.self){ a in
                                Circle()
                                    .stroke(.black, style: StrokeStyle(lineWidth: 1, dash: [3]))
                                    .frame(width: 30)
                                    .background(noteColor())
                                    .onAppear{
                                        print(Double(compassController.compass.pulseDuration)/nota.duration)
                                    }
                                if a != Int(Double(compassController.compass.pulseDuration)*nota.duration){
                                    Spacer()
                                }

                            }
                        }
                        .frame(width: noteWidth(screenRect: screenRect, nota: nota))
                    }
                    HStack{
                        if showCircle(){
                            Circle()
                                .frame(width: 30)
                                .foregroundStyle(.black)
                        }else{
                            HStack{
                                Circle()
                                    .frame(width: 30)
                                    .foregroundColor(.black)
                                    .offset(x: animationProgress)
                                Spacer()
                            }.frame(width: noteWidth(screenRect: screenRect, nota: nota))
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
            }.onChange(of: compassController.currentNoteIndex) { oldValue, newValue in
                if newValue == actIndex && isShowMode() {
                    startMotion(screenRect: screenRect)
                    volta = true
                } else if newValue != actIndex && isShowMode() && volta == true{
                    undoMotion(screenRect: screenRect)
                    volta = false
                }
            }
        }
        .sensoryFeedback(.success, trigger: compassController.currentNoteIndex)
        .onAppear{
            animationProgress = 0
        }
    }
    func noteWidth(screenRect: CGRect, nota: Note) -> Double {
        // Calculando tamanho total da barra com base na orientação
        var barWidth = screenRect.width*0.8
        if configController.config.orientationLock || orientation.isPortrait || orientation.isFlat {
            barWidth = screenRect.height*0.8
        }
        
        // Calculando o duration multiplier
        let durationMultiplier = nota.duration == 0.5 ? 0.5 : 0.75
        
        // Calculando versão final do width
        let pulseCount = Double(compassController.compass.pulseCount)
        let pulseDuration = Double(compassController.compass.pulseDuration)
        return durationMultiplier*barWidth*nota.duration*pulseDuration/pulseCount
    }
    
    func noteColor() -> Color {
        if (!lightedUp) {
            return nota.color.opacity(1)
        }
        else {
            return .white
        }
    }
    
    func calcScreenSize(screenBounds: CGRect) -> CGRect {
        if configController.config.orientationLock {
            return CGRect(origin: screenBounds.origin, size: CGSize(width: screenBounds.height, height: screenBounds.width))
        }
        return screenBounds
    }
    
    func isBigNote() -> Bool {
        return nota.duration > 1.0/Double(compassController.compass.pulseDuration)
    }
    
    func isShowMode() -> Bool {
        return !orientation.isPortrait || configController.config.orientationLock
    }
    
    func showBeatLine() -> Bool {
        return isShowMode() && isBigNote()
    }
    
    func showCircle() -> Bool {
        return showcase || !showBeatLine()
    }
    
    func startMotion(screenRect: CGRect){
        animationProgress = 0
        // Start the animation when the view appears
        
        // Ball animation
        withAnimation(Animation.linear(duration: 4*nota.duration)) {
            animationProgress = noteWidth(screenRect: screenRect, nota: nota)-25
        }
        // Color animation
        withAnimation(.linear(duration: 1)){
            self.lightedUp = true
            withAnimation(.linear(duration: 1)){
                self.lightedUp = false
            }
        }
    }
    
    func undoMotion(screenRect: CGRect){
        animationProgress = noteWidth(screenRect: screenRect, nota: nota)-25
        // Start the animation when the view appears
        
        // Ball animation
        withAnimation(Animation.linear(duration: nota.duration)) {
            animationProgress = 0
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
