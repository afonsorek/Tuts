//
//  ContentView.swift
//  BeatsTest
//
//  Created by Afonso Rekbaim on 26/10/23.
//
import AVFoundation
import SwiftUI

struct ContentView: View {
    @State var bpm: Double
    @ObservedObject var time: TimeController

    init(bpm: Double) {
        self.bpm = bpm
        self.time = TimeController(beatsPerMinute: bpm)
    }
    
    let soundManager = SoundManager()
    
    //Define as notas e o tempo respectivo de cada uma
    let notas: [String:Double] = ["Semibreve" : 1, "Minima" : 1/2, "Seminima" : 1/4, "Colcheia" : 1/8, "Semicolcheia" : 1/16, "Fusa" : 1/32, "Semifusa" : 1/64, "Quartifusa" : 1/128]
    
    @State private var Selected = ""
    @State private var SelectedBPM = "60"
    @State private var animation = 0.0
    
    @State var compasso = 4
    
    var body: some View {
        VStack{
            Canvas { context, size in
                    }
                .overlay {
                    ZStack{
                        RoundedRectangle(cornerSize: CGSize(width: 50, height: 50))
                            .foregroundStyle(.black)
                            .frame(width: 300, height: 350)
                        VStack{
                            Text("Tempo = \(Int(time.beats.truncatingRemainder(dividingBy: 4)+1))")
                                .foregroundStyle(.white)
                            Text(Selected)
                                .font(.system(size: 40))
                                .foregroundStyle(.white)
                            Image("\(Selected)-Nota")
                            
                            
                            ZStack{
                                Rectangle()
                                HStack{
                                    Rectangle()
                                        .frame(width: 240/4, height: 50)
                                        .foregroundStyle(.green)
                                        .opacity(Int(time.beats.truncatingRemainder(dividingBy: 4)+1) == 1 ? 1.0 : 0.0)
                                    Rectangle()
                                        .frame(width: 240/4, height: 50)
                                        .foregroundStyle(.green)
                                        .opacity(Int(time.beats.truncatingRemainder(dividingBy: 4)+1) == 2 ? 1.0 : 0.0)
                                    Rectangle()
                                        .frame(width: 240/4, height: 50)
                                        .foregroundStyle(.green)
                                        .opacity(Int(time.beats.truncatingRemainder(dividingBy: 4)+1) == 3 ? 1.0 : 0.0)
                                    Rectangle()
                                        .frame(width: 240/4, height: 50)
                                        .foregroundStyle(.green)
                                        .opacity(Int(time.beats.truncatingRemainder(dividingBy: 4)+1) == 4 ? 1.0 : 0.0)
                                }
                            }
                            .frame(width: 270, height: 50)
                            .foregroundStyle(.white)
                        }
                    }
                    .dropDestination(for: String.self) { items, _ in
                        
                        print("Itens do drop: \(items)")
                        
                        let itemsSplit = items[0].components(separatedBy: ":")
                        
                        print(itemsSplit)
                        
                        Selected = itemsSplit.first ?? ""

                        soundManager.stopAll()
                        
                        if Int(time.beats.truncatingRemainder(dividingBy: 4)+1) == 1{
                            soundManager.playLoop(sound: .beat, split: itemsSplit.last ?? "", tempo: "4/4", check: 0)
                        }else {
                            soundManager.playLoop(sound: .beat, split: itemsSplit.last ?? "", tempo: "4/4", check: 0)
                        }
                        
                        
                        return true
                    }
                    .foregroundStyle(.black)
                }.frame(height: 400)
            HStack{
                Spacer()
                TextField("BPM", text: $SelectedBPM)
                    .frame(width: 100)
                    .multilineTextAlignment(.center)
                    .disabled(true)
                Button("-"){
                    SelectedBPM = String(Int(SelectedBPM)!-1)
                    time.setBeatsPerMinute(Double(SelectedBPM) ?? 60)
                }
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.black)
                .padding(.horizontal)
                Button("+"){
                    SelectedBPM = String(Int(SelectedBPM)!+1)
                    time.setBeatsPerMinute(Double(SelectedBPM) ?? 60)
                }
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.black)
                .padding(.horizontal)
                Spacer()
            }
            .padding()
            ScrollView(.horizontal){
                HStack{
                    ForEach(Array(notas.keys).sorted(by: { notas[$0] ?? 0 > notas[$1] ?? 0 }), id: \.self) { nota in
                        let value = notas[nota] ?? 0

                        Image("\(nota)-Nota")
                            .draggable("\(String(nota)):\(String(value))")
                            
                    }
                }
                .padding(.leading, 20)
            }
            .padding(.bottom, 50)
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    ContentView(bpm: 60)
}
