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
    
    var body: some View {
        VStack{
            ZStack{
                VStack{
                    ZStack{
                        HStack{
                            TextField("", text: compassController.pulseCountStringBinding)
                                .frame(width: 10)
                                .foregroundStyle(Color(red: 0.28, green: 0.2, blue: 0.45))
                            Text("/")
                                .foregroundStyle(Color(red: 0.28, green: 0.2, blue: 0.45))
                            TextField("", text: compassController.pulseDurationStringBinding)
                                .frame(width: 10)
                                .foregroundStyle(Color(red: 0.28, green: 0.2, blue: 0.45))
                            Spacer()
                        }
                        .padding(.horizontal, 13)
                        .padding(.vertical, 11)
                    }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 16, height: 16)))
                    
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
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    PortraitView(compassController: CompassController())
}
