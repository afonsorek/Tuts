//
//  PortraitView.swift
//  BeatsTest
//
//  Created by Rafa (Ruffles) on 09/11/23.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var popup = false
}

struct PortraitView: View {
    @Binding var mostrandoTela: Int
    
    @ObservedObject var compassController : CompassController
    @ObservedObject var timeController = TimeController.shared
    @ObservedObject var configController = ConfigController.shared
    
    @StateObject private var appState = AppState() // Use StateObject here
    
    @State var edit = ""
    @State var flip = false
    @State var alert = false
    
    @State var buttonScaleEffect = 1.0
    @State var buttonScaleEffect2 = 1.0
    @State var scaleAnimation = 1.0
    @State var scaleAnimation2 = 1.0
    
    var body: some View {
        ZStack{
            VStack{
                ZStack{
                    VStack{
                        HStack{
                            Spacer()
                            Button(action: {
                                withAnimation(.easeInOut){
                                    mostrandoTela = 1
                                }
                            }, label: {
                                Image(systemName: "gearshape.fill")
                                    .font(
                                    Font.custom("SF Pro Text", size: 36)
                                    .weight(.semibold)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                            })
                        }
                        .padding(.trailing, 25)
                        .padding(.vertical, 45)
                        Spacer()
                        HStack{
                            ZStack{
                                HStack(spacing: 1){
                                    Text("\(compassController.compass.pulseCount)")
                                        .font(.title3)
                                        .bold()
                                        .foregroundStyle(.white)
                                    Text("/")
                                        .font(.title3)
                                        .bold()
                                        .foregroundStyle(.white)
                                    Text("\(compassController.compass.pulseDuration)")
                                        .font(.title3)
                                        .bold()
                                        .foregroundStyle(.white)
                                }
                                .padding(.horizontal, 13)
                                .padding(.vertical, 11)
                            }
                            .background(Color(white: 1, opacity: 0.1))
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 16, height: 16)))
                            .onTapGesture {
                                edit = "compass"
                                withAnimation(.linear(duration: 0.3)){
                                    appState.popup = true
                                }
                            }
                            Spacer()
                            ZStack{
                                HStack(spacing: 0){
                                    Image(systemName: "metronome")
                                        .font(.title3)
                                        .bold()
                                        .foregroundStyle(.white)

                                    Text(" \(Int(timeController.BPM)) BPM")
                                        .font(.title3)
                                        .bold()
                                        .foregroundStyle(.white)
                                }
                                .padding(.horizontal, 13)
                                .padding(.vertical, 11)
                            }
                            .scaleEffect(scaleAnimation)
                            .background(Color(white: 1, opacity: 0.1))
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 16, height: 16)))
                            .onTapGesture {
                                edit = "bpm"
                                ScaleAnimation()
                                withAnimation(.linear(duration: 0.3)){
                                    appState.popup = true
                                }
                            }
                            .padding(.trailing, 26)
                        }
                        .padding(.leading, 32)
                        .padding(.bottom, 11)
                        
                        ScrollView(.horizontal){
                            BarView(compassController: compassController)
                        }
                        .padding(.leading, 16.5)
                        .frame(maxWidth: .infinity)
                        
                        HStack{
                            ZStack{
                                HStack{
                                    Text("Limpar")
                                        .font(.title3)
                                        .bold()
                                        .foregroundStyle(.white)
                                }
                                .padding(.horizontal, 13)
                                .padding(.vertical, 11)
                            }
                            .scaleEffect(CGSize(width: buttonScaleEffect, height: buttonScaleEffect))
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 16, height: 16)))
                            .onTapGesture {
                                withAnimation(.linear(duration: 0.3)){
                                    compassController.removeAllNotes()
                                    buttonScaleEffect -= 0.4
                                    withAnimation(.easeOut(duration: 0.3)){
                                        buttonScaleEffect = 1.0
                                    }
                                }
                            }
                            .overlay(
                            RoundedRectangle(cornerRadius: 16)
                            .inset(by: 0.5)
                            .stroke(.white, lineWidth: 1)
                            .scaleEffect(CGSize(width: buttonScaleEffect, height: buttonScaleEffect))
                            )
                            
                            ZStack{
                                HStack{
                                    Image(systemName: "arrow.uturn.backward")
                                        .font(.title3)
                                        .bold()
                                        .foregroundStyle(.white)
                                }
                                .padding(.horizontal, 13)
                                .padding(.vertical, 11)
                            }
                            .scaleEffect(CGSize(width: buttonScaleEffect2, height: buttonScaleEffect2))
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 16, height: 16)))
                            .onTapGesture {
                                withAnimation(.linear(duration: 0.3)){
                                    compassController.removeNote()
                                    buttonScaleEffect2 -= 0.4
                                    withAnimation(.easeOut(duration: 0.3)){
                                        buttonScaleEffect2 = 1.0
                                    }
                                }
                            }
                            .overlay(
                            RoundedRectangle(cornerRadius: 16)
                            .inset(by: 0.5)
                            .stroke(.white, lineWidth: 1)
                            .scaleEffect(CGSize(width: buttonScaleEffect2, height: buttonScaleEffect2))
                            )
                            Spacer()
                            ZStack{
                                HStack(spacing: 0){
                                    Image(systemName: "checkmark")
                                        .font(.title3)
                                        .bold()
                                        .foregroundStyle(compassController.compass.remainingSize < 1 ? Color(red: 0.28, green: 0.2, blue: 0.45) : .white)
                                }
                                .padding(.horizontal, 13)
                                .padding(.vertical, 11)
                            }
                            .background(compassController.compass.remainingSize < 1 ? .white : .clear)
                            .opacity(compassController.compass.remainingSize < 1 ? 1.0 : 0.5)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 16, height: 16)))
                            .onTapGesture {
                                withAnimation(.linear(duration: 0.3)){
                                    //LOGICA DE ROTAÇÃO RAFA
                                    if compassController.compass.remainingSize < 1{
                                        configController.toggleOrientationLock()
                                    } else {
                                        withAnimation{
                                            alert = true
                                        }
                                    }
                                }
                            }
                            .overlay(
                            RoundedRectangle(cornerRadius: 16)
                            .inset(by: 0.5)
                            .stroke(.white, lineWidth: 1)
                            )
                            .padding(.trailing, 26)
                            .opacity(compassController.compass.remainingSize < 1 ? 1.0 : 0.5)
                        }
                        .padding(.leading, 32)
                        .padding(.vertical, 14.5)
                    }
                }
                .foregroundStyle(.black)
                .frame(height: 400)
                
                
                if alert{
                    Text("Selecione pelo menos uma das notas abaixo.")
                        .foregroundStyle(.white)
                        .bold()
                        .onAppear{
                            withAnimation(.easeIn(duration: 3)){
                                alert = false
                            }
                        }
                }
                
                Spacer()
                
                ScrollView(.horizontal){
                    HStack(spacing: 25){
                        ForEach(NotesData.notes, id: \.self) { nota in
                            NoteView(nota: nota, showcase: true, compassController: compassController)
                                .sensoryFeedback(.impact, trigger: compassController.compass.notes)
                                .frame(width: 76, height: 163)
                                .shadow(color: Color(white: 0, opacity: 0.25), radius: 4, y: 4)
                        }
                        .frame(maxHeight: .infinity)
                    }
                    .padding(.leading, 20)
                }
                .frame(height: 236)
                .frame(maxWidth: .infinity)
                .background(Color(white: 1, opacity: 0.2))
                .scrollIndicators(.hidden)
            }
            if appState.popup { // Use appState.popup here
                PopupView(compassController: compassController, editing: edit, isPopupVisible: $appState.popup)
            }
        }
        .frame(maxHeight: .infinity)
        .environmentObject(appState)
    }
    
    func ScaleAnimation(){
        withAnimation(.linear(duration: 0.3)){
            scaleAnimation -= 0.5
            withAnimation(.linear(duration: 0.2)){
                scaleAnimation += 0.5
            }
        }
    }
    
    func ScaleAnimation2(){
        withAnimation(.linear(duration: 0.3)){
            scaleAnimation -= 0.5
            withAnimation(.linear(duration: 0.2)){
                scaleAnimation += 0.5
            }
        }
    }
}


#Preview {
    PortraitView(mostrandoTela: .constant(0), compassController: CompassController())
        .environmentObject(AppState())
}
