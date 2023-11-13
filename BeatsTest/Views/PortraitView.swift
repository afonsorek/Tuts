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
    @ObservedObject var compassController : CompassController
    @ObservedObject var timeController = TimeController.shared
    @ObservedObject var configController = ConfigController.shared
    
    @StateObject private var appState = AppState() // Use StateObject here
    
    @State var edit = ""
    
    var body: some View {
        ZStack{
            VStack{
                ZStack{
                    VStack{
                        HStack{
                            ZStack{
                                HStack{
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
                                    Text("\(Int(timeController.BPM)) BPM")
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
                                edit = "bpm"
                                withAnimation(.linear(duration: 0.3)){
                                    appState.popup = true
                                }
                            }
                            .padding(.trailing, 26)
                        }
                        .padding(.leading, 32)
                        .padding(.bottom, 14.5)
                        
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
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 16, height: 16)))
                            .onTapGesture {
                                withAnimation(.linear(duration: 0.3)){
                                    compassController.removeAllNotes()
                                }
                            }
                            .overlay(
                            RoundedRectangle(cornerRadius: 16)
                            .inset(by: 0.5)
                            .stroke(.white, lineWidth: 1)

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
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 16, height: 16)))
                            .onTapGesture {
                                withAnimation(.linear(duration: 0.3)){
                                    compassController.removeNote()
                                }
                            }
                            .overlay(
                            RoundedRectangle(cornerRadius: 16)
                            .inset(by: 0.5)
                            .stroke(.white, lineWidth: 1)

                            )
                            Spacer()
                            ZStack{
                                HStack(spacing: 0){
                                    Image(systemName: "checkmark")
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
                                withAnimation(.linear(duration: 0.3)){
                                    //LOGICA DE ROTAÇÃO RAFA
                                }
                            }
                            .overlay(
                            RoundedRectangle(cornerRadius: 16)
                            .inset(by: 0.5)
                            .stroke(.white, lineWidth: 1)

                            )
                            .padding(.trailing, 26)
                        }
                        .padding(.leading, 32)
                        .padding(.vertical, 14.5)
                    }
                }
                .foregroundStyle(.black)
                .frame(height: 400)
                ScrollView(.horizontal){
                    HStack{
                        ForEach(NotesData.notes.sorted(by: {$0.duration > $1.duration }), id: \.self) { nota in
                            Image(nota.imageName)
                                .onTapGesture {
                                    withAnimation(.linear(duration: 0.3)){
                                        _ = compassController.addNote(note: nota)
                                    }
                                }
                        }
                    }
                    .padding(.leading, 20)
                }
                .padding(.bottom, 50)
                .scrollIndicators(.hidden)
            }
            if appState.popup { // Use appState.popup here
                PopupView(compassController: compassController, editing: edit, isPopupVisible: $appState.popup)
            }
        }
        .frame(maxHeight: .infinity)
        .environmentObject(appState)
    }
}

#Preview {
    PortraitView(compassController: CompassController())
        .environmentObject(AppState())
}
