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
    let showcase : Bool
    let actIndex : Int
    
    init(nota: Note, showcase: Bool, compassController: CompassController? = nil, actIndex: Int = -1) {
        self.nota = nota
        self.showcase = showcase
        self.compassController = compassController ?? CompassController()
        self.actIndex = actIndex
    }
    
    @State var animationProgress = 0.0
    @State var scaleAnimation = 1.0
    @State var lightedUp = false
    @State var volta = false
    @State var isPausa = false
    
    var body: some View {
        let screenBounds = UIScreen.main.bounds
        let screenSize = calcScreenSize(screenBounds: screenBounds)
        ZStack{
            Rectangle()
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white, style: StrokeStyle(lineWidth: showcase ? 6 : 2, dash: [isPausa ? 3 : .infinity])))
                .cornerRadius(20)
                .foregroundColor(noteColor())
            VStack (spacing: 13) {
                ZStack{
                    if UIDevice.current.orientation.isLandscape && nota.duration > 1.0/Double(compassController.compass.pulseDuration){
                        Rectangle()
                            .stroke(LinearGradient(colors: [.black.opacity(1), .black.opacity(0)], startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 1, dash: [3]))
                            .frame(height: 1)
                            .frame(width: nota.duration != 0.5 ? noteWidth(screenSize: screenSize, nota: nota)*0.75 : noteWidth(screenSize: screenSize, nota: nota)*0.5)
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
                        .frame(width: nota.duration != 0.5 ? noteWidth(screenSize: screenSize, nota: nota)*0.75 : noteWidth(screenSize: screenSize, nota: nota)*0.5)
                    }
                    HStack{
                        if showcase || !UIDevice.current.orientation.isLandscape || nota.duration <= 1.0/Double(compassController.compass.pulseDuration){
                            if !isPausa{
                                Circle()
                                    .frame(width: 30)
                                    .foregroundStyle(.black)
                            }else{
                                Circle()
                                    .stroke(.white, style: StrokeStyle(lineWidth: 4, dash: [3]))
                                    .frame(width: 30)
                                    .foregroundStyle(.clear)
                            }
                        }else{
                            HStack{
                                Circle()
                                    .frame(width: 30)
                                    .foregroundColor(.black)
                                    .offset(x: animationProgress)
                                Spacer()
                            }.frame(width: nota.duration != 0.5 ? noteWidth(screenSize: screenSize, nota: nota)*0.75 : noteWidth(screenSize: screenSize, nota: nota)*0.5)
                        }
                    }
                }
                Rectangle()
                    .frame(height: 1)
                    .padding(.horizontal, 10)
                    .foregroundStyle(.white)
                if isPausa{
                    Image("\(nota.name.lowercased())-pausa")
                        .scaleEffect(0.7)
                        .frame(height: 30)
                        .padding(.top, 10)
                        .colorInvert()
                }else{
                    Image(nota.name.lowercased())
                        .scaleEffect(0.7)
                        .frame(height: 30)
                        .padding(.top, 10)
                }
                    
            }.onChange(of: compassController.currentNoteIndex) { oldValue, newValue in
                if newValue == actIndex && UIDevice.current.orientation.isLandscape{
                    startMotion(screenSize: screenSize)
                    volta = true
                } else if newValue != actIndex && UIDevice.current.orientation.isLandscape && volta == true{
                    undoMotion(screenSize: screenSize)
                    volta = false
                }
            }
        }
        .scaleEffect(scaleAnimation)
        .sensoryFeedback(.success, trigger: compassController.currentNoteIndex)
        .sensoryFeedback(.success, trigger: isPausa)
        .onAppear{
            animationProgress = 0
        }
//        .onLongPressGesture {
//            isPausa.toggle()
//            ColorAnimation()
//            ScaleAnimation()
//        }
    }
    func noteWidth(screenSize: CGRect, nota: Note) -> Double {
        let pulseCount = Double(compassController.compass.pulseCount)
        let pulseDuration = Double(compassController.compass.pulseDuration)
        return (orientation.isPortrait || orientation.isFlat ? UIScreen.main.bounds.height*0.8 : UIScreen.main.bounds.width*0.8)*nota.duration*pulseDuration/pulseCount
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
    
    func ColorAnimation(){
        // Color animation
        withAnimation(.linear(duration: 0.2)){
            self.lightedUp = true
            withAnimation(.linear(duration: 0.3)){
                self.lightedUp = false
            }
        }
    }
    
    func ScaleAnimation(){
        withAnimation(.linear(duration: 0.3)){
            scaleAnimation -= 0.5
            withAnimation(.linear(duration: 0.2)){
                scaleAnimation += 0.5
            }
        }
    }
    
    func startMotion(screenSize: CGRect){
        animationProgress = 0
        // Start the animation when the view appears
        
        // Ball animation
        withAnimation(Animation.linear(duration: 4*nota.duration)) {
            animationProgress = (nota.duration != 0.5 ? noteWidth(screenSize: screenSize, nota: nota)*0.75 : noteWidth(screenSize: screenSize, nota: nota)*0.5)-25
        }
        
        ColorAnimation()
        ScaleAnimation()
    }
    
    func undoMotion(screenSize: CGRect){
        animationProgress = (nota.duration != 0.5 ? noteWidth(screenSize: screenSize, nota: nota)*0.75 : noteWidth(screenSize: screenSize, nota: nota)*0.5)-25
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
