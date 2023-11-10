//
//  PortraitView.swift
//  BeatsTest
//
//  Created by Rafa (Ruffles) on 09/11/23.
//

import SwiftUI

struct PortraitView: View {
    @ObservedObject var compassController : CompassController
    @ObservedObject var timeController = TimeController.shared
    
    @State var popup = false
    
    var body: some View {
        ZStack{
            VStack{
                ZStack{
                    VStack{
                        HStack{
                            ZStack{
                                HStack{
                                    Picker("", selection: compassController.pulseCountStringBinding) {
                                        ForEach(1...32, id: \.self) {
                                            Text("\($0)")
                                        }
                                    }
                                    .pickerStyle(.inline)
                                    .frame(width: 10)
                                    .foregroundStyle(Color(red: 0.28, green: 0.2, blue: 0.45))
                                        
                                    Text("/")
                                        .foregroundStyle(Color(red: 0.28, green: 0.2, blue: 0.45))
                                    Text("\(compassController.compass.pulseDuration)")
                                        .onTapGesture {
                                            popup = true
                                        }
                                }
                                .padding(.horizontal, 13)
                                .padding(.vertical, 11)
                            }
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 16, height: 16)))
                            Spacer()
                        }
                        .padding(.leading, 32)
                        .padding(.bottom, 14.5)
                        
                        ScrollView(.horizontal){
                            BarView(compassController: compassController)
                        }
                        .padding(.leading, 16.5)
                        .frame(maxWidth: .infinity)
                    }
                }
                .foregroundStyle(.black)
                .frame(height: 400)
                HStack{
                    Spacer()
                    Text(String(timeController.BPM))
                        .frame(width: 100)
                        .multilineTextAlignment(.center)
                        .disabled(true)
                    Button("-"){
                        timeController.setBeatsPerMinute(timeController.BPM - 1)
                        timeController.resetTimer()
                    }
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                    .padding(.horizontal)
                    Button("+"){
                        timeController.setBeatsPerMinute(timeController.BPM + 1)
                        timeController.resetTimer()
                    }
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                    .padding(.horizontal)
                    Spacer()
                }
                .padding()
                ScrollView(.horizontal){
                    HStack{
                        ForEach(NotesData.notes.sorted(by: {$0.duration > $1.duration }), id: \.self) { nota in
                            Image(nota.imageName)
                                .onTapGesture {
                                    _ = compassController.addNote(note: nota)
                                }
                        }
                    }
                    .padding(.leading, 20)
                }
                .padding(.bottom, 50)
                .scrollIndicators(.hidden)
            }
            if popup{
                PopupView()
            }
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    PortraitView(compassController: CompassController())
}
