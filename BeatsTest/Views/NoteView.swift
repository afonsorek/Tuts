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
    
    let nota: Note
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
    @State var transparent = true
    
    var body: some View {
        let screenBounds = UIScreen.main.bounds
        let screenSize = calcScreenSize(screenBounds: screenBounds)
        ZStack{
            Rectangle()
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white, lineWidth: showcase ? 6 : 2))
                .cornerRadius(20)
                .foregroundColor(noteColor())
            VStack (spacing: 13) {
                ZStack{
                    if UIDevice.current.orientation.isLandscape && nota.duration > 1.0/Double(compassController.compass.pulseDuration){
                        Rectangle()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                            .frame(height: 1)
                            .padding(.horizontal, 20)
                    }
                    HStack{
                        if showcase || !UIDevice.current.orientation.isLandscape || nota.duration < 1.0/Double(compassController.compass.pulseDuration){
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
                if newValue == actIndex && UIDevice.current.orientation.isLandscape{
                    print("Função de movimento chamada")
                    startMotion(screenSize: screenSize)
                }
            }
        }
        .onAppear{
            animationProgress = screenSize.width*0.1*(4.0*nota.duration)/4.0
        }
    }
    
    func noteColor() -> Color {
        if (!lightedUp) {
            return nota.color
        }
        else {
            return .white.opacity(transparent ? 0 : 1)
        }
    }
    
    func calcScreenSize(screenBounds: CGRect) -> CGRect {
        if configController.config.orientationLock {
            return CGRect(origin: screenBounds.origin, size: CGSize(width: screenBounds.height, height: screenBounds.width))
        }
        return screenBounds
    }
    
    func startMotion(screenSize: CGRect){
        animationProgress = screenSize.width*0.1*(4.0*nota.duration)/4.0
        // Start the animation when the view appears
        
        // Ball animation
        withAnimation(Animation.linear(duration: 4*nota.duration)) {
            animationProgress = screenSize.width*0.5*(Double(4) * nota.duration)/Double(4)
        }
//        // Color animation
//        withAnimation(.linear(duration: 1)){
//            self.transparent = true
//            self.lightedUp = true
//            withAnimation(.linear(duration: 1)){
//                self.transparent = false
//            }
//        }
    }
}

#Preview {
    VStack {
        ForEach(NotesData.notes, id: \.self) { nota in
            NoteView(nota: nota, showcase: false)
        }
    }
}
