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
    @ObservedObject var configController = ConfigController.shared
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerSize: CGSize(width: 50, height: 50))
                    .foregroundStyle(.black)
                    .frame(width: 300, height: 350)
                VStack{
                    Text("Espaços sobrando: \(compassController.compass.remainingSize)")
                        .foregroundStyle(.white)
                    HStack{
                        Spacer()
                        TextField("", text: compassController.pulseCountStringBinding)
                            .frame(width: 10)
                            .foregroundStyle(.white)
                        Text("/")
                            .foregroundStyle(.white)
                        TextField("", text: compassController.pulseDurationStringBinding)
                            .frame(width: 10)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    Text("Tempo = \(timeController.beats.truncatingRemainder(dividingBy: Double(compassController.compass.pulseCount))+1)")
                        .foregroundStyle(.white)
                    ScrollView(.horizontal){
                        HStack{
                            if compassController.compass.notes.count >= 1 {
                                ForEach (0..<compassController.compass.notes.count, id: \.self){ i in
                                    VStack(spacing: 0){
                                        Text(compassController.compass.notes[i].name)
                                            .font(.system(size: 10))
                                            .foregroundStyle(.white)
                                        Image(compassController.compass.notes[i].imageName)
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                    }
                                }
                            }
                        }
                    }.frame(width: 300)
                    
                    ZStack{
                        Rectangle()
                        HStack{
                            ForEach(1...compassController.compass.pulseCount, id: \.self) { i in
                                Rectangle()
                                    .frame(width: 240/CGFloat(compassController.compass.pulseCount), height: 50)
                                    .foregroundStyle(.green)
                                    .opacity(Int(timeController.beats.truncatingRemainder(dividingBy: Double(compassController.compass.pulseCount))+1) == i ? 1.0 : 0.0)
                            }
                        }
                    }
                    .frame(width: 270, height: 50)
                    .foregroundStyle(.white)
                    
                    Toggle(isOn: configController.orientationBinding) {
                        Text("Lock de tela")
                            .foregroundStyle(.white)
                    }
                    .frame(width: 250, height: 50)
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
                            .draggable("\(String(nota.name)):\(String(nota.duration))")
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
