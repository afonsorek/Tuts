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
    @ObservedObject var rotationController = RotationController.shared
    @ObservedObject var timeController = TimeController.shared
    
    @State var nota: Note
    let showcase : Bool
    let actIndex : Int
    let animationEndOffset : Double = 30
    
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
    @State private var isLongPressing = false
    
    var body: some View {
        ZStack{
            Rectangle()
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(configController.noteColors ? .white : .black, style: StrokeStyle(lineWidth: showcase ? 6 : 2, dash: [nota.pause ? 3 : .infinity])))
                .cornerRadius(20)
                .foregroundColor(noteColor())
            VStack (spacing: 13) {
                if configController.showBeats{
                    ZStack{
                        if showBeatLine(){
                            Rectangle()
                                .stroke(LinearGradient(colors: [.black.opacity(1), .black.opacity(0)], startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 1, dash: [3]))
                                .frame(height: 1)
                                .frame(width: noteWidth(nota: nota))
                            HStack{
                                ForEach (1...Int(Double(compassController.compass.pulseDuration)*nota.duration+1), id: \.self){ a in
                                    Circle()
                                        .stroke(.black, style: StrokeStyle(lineWidth: a != Int(Double(compassController.compass.pulseDuration)*nota.duration+1) ? 1 : 0, dash: [3]))
                                        .frame(width: 30)
                                        .background(noteColor())
    //                                Spacer()
                                    if a != Int(Double(compassController.compass.pulseDuration)*nota.duration+1){
                                        Spacer()
                                    }

                                }
                            }
                            .frame(width: noteWidth(nota: nota))
                        }
                        HStack{
                            if showCircle(){
                                if nota.pause {
                                    Circle()
                                        .stroke(configController.noteColors ? .white : .black, style: StrokeStyle(lineWidth: 4, dash: [3]))
                                        .frame(width: 30)
                                        .foregroundStyle(.clear)
                                }
                                else {
                                    Circle()
                                        .frame(width: 30)
                                        .foregroundStyle(.black)
                                }
                            }else{
                                HStack{
                                    Circle()
                                        .frame(width: 30)
                                        .foregroundColor(.black)
                                        .offset(x: animationProgress)
                                    Spacer()
                                }.frame(width: noteWidth(nota: nota))
                            }
                        }
                    }
                    Rectangle()
                        .frame(height: 1)
                        .padding(.horizontal, 10)
                        .foregroundStyle(configController.noteColors ? .white : .black)
                }
                if nota.pause && configController.noteColors{
                    Image("\(nota.name.lowercased())-pausa")
                        .scaleEffect(0.7)
                        .frame(height: 30)
                        .padding(.top, 10)
                        .colorInvert()
                }else if nota.pause && !configController.noteColors{
                    Image("\(nota.name.lowercased())-pausa")
                        .scaleEffect(0.7)
                        .frame(height: 30)
                        .padding(.top, 10)
                }else{
                    Image(nota.name.lowercased())
                        .scaleEffect(0.7)
                        .frame(height: 30)
                        .padding(.top, 10)
                }
                    
            }
            .onAppear() {
                compassController.currentNoteIndexListeners.append({ noteIndex in
                    if noteIndex == actIndex && RotationController.isShowMode() {
                        startMotion()
                    } else if noteIndex != actIndex && noteIndex >= 0 && RotationController.isShowMode() && animationProgress == endAnimationProgress(){
                        undoMotion()
                    }
                })
            }
        }
        .scaleEffect(scaleAnimation)
        //.sensoryFeedback(.success, trigger: compassController.currentNoteIndex)
        .sensoryFeedback(.success, trigger: nota)
        .onTapGesture {
            if (showcase) {
                withAnimation(.linear(duration: 0.3)){
                    _ = compassController.addNote(note: nota)
                }
            }
        }
        .onLongPressGesture {
            if !showcase{
                nota = nota.togglePause()
                compassController.setNotePause(noteIndex: actIndex, pause: nota.pause)
                ColorAnimation()
                ScaleAnimation()
            }
        }
// ------------------------------- NOVA FUNÇÃO DE VIBRAÇÃO ----------------------
//        .onLongPressGesture(
//            perform: {
//                if !showcase{
//                    nota = nota.togglePause()
//                    compassController.setNotePause(noteIndex: actIndex, pause: nota.pause)
//                    ColorAnimation()
//                    ScaleAnimation()
//            },
//            onPressingChanged: { isPressing in
//                withAnimation {
//                    if isPressing {
//                        // Inicia o timer para a vibração contínua
//                        startVibrationTimer()
//                    } else {
//                        // Para o timer quando o gesto de long press é encerrado
//                        stopVibrationTimer()
//                    }
//                }
//            }
//        )
    }
    
//    // Função para iniciar o timer
//    func startVibrationTimer() {
//        isLongPressing = true
//        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
//            if isLongPressing {
//                // Adicionar feedback tátil
//                let generator = UIImpactFeedbackGenerator(style: .medium)
//                generator.impactOccurred()
//            } else {
//                // Se o gesto de long press não estiver mais ocorrendo, para o timer
//                timer.invalidate()
//            }
//        }
//    }
//
//    // Função para parar o timer
//    func stopVibrationTimer() {
//        isLongPressing = false
//    }
    
    func togglePause() {
        nota = Note(name: nota.name, duration: nota.duration, color: nota.color, pause: !nota.pause)
    }
    
    func noteWidth(nota: Note) -> Double {
        // Calculando tamanho total da barra com base na orientação
        let barWidth = rotationController.screenRect.width*0.8
        
        // Calculando o duration multiplier
        let durationMultiplier = nota.duration == 0.5 ? 0.5 : 0.75
        
        // Calculando versão final do width
        let pulseCount = Double(compassController.compass.pulseCount)
        let pulseDuration = Double(compassController.compass.pulseDuration)
        return durationMultiplier*barWidth*nota.duration*pulseDuration/pulseCount
    }
    
    func noteColor() -> Color {
        if configController.noteColors{
            if (!lightedUp) {
                return nota.color.opacity(1)
            }
            else {
                return .white
            }
        }else{
            if (!lightedUp) {
                return Color(red: 0.94, green: 0.91, blue: 1)
            }
            else {
                return Color(red: 0.16, green: 0.11, blue: 0.26)
            }
        }
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
    func isBigNote() -> Bool {
        return nota.duration > 1.0/Double(compassController.compass.pulseDuration)
    }
    
    func showBeatLine() -> Bool {
        return RotationController.isShowMode() && isBigNote()
    }
    
    func showCircle() -> Bool {
        return showcase || !showBeatLine()
    }
    
    func startMotion(){
        animationProgress = 0
        
        // Ball animation
        withAnimation(Animation.linear(duration: 4*nota.duration*60.0/Double(timeController.BPM))) {
            animationProgress = endAnimationProgress()
        }
        
        ColorAnimation()
        ScaleAnimation()
    }
    
    func undoMotion(){
        animationProgress = endAnimationProgress()

        // Ball animation
//        withAnimation(Animation.linear(duration: nota.duration*60.0/Double(timeController.BPM))) {
        withAnimation(Animation.easeInOut(duration: (1/4)*nota.duration*60.0/Double(timeController.BPM))) {
            animationProgress = 0
        }
    }
    
    func endAnimationProgress() -> Double {
        noteWidth(nota: nota)-animationEndOffset
    }
}

#Preview {
    VStack {
        ForEach(NotesData.notes, id: \.self) { nota in
            NoteView(nota: nota, showcase: false)
        }
    }
}
