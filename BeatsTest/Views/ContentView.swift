//
//  ContentView.swift
//  BeatsTest
//
//  Created by Afonso Rekbaim on 26/10/23.
//
import AVFoundation
import SwiftUI

struct ContentView: View {
    let soundManager = SoundManager()
    
    //Define as notas e o tempo respectivo de cada uma
    let notas: [String:Double] = ["Semibreve" : 1, "Minima" : 1/2, "Seminima" : 1/4, "Colcheia" : 1/8, "Semicolcheia" : 1/16, "Fusa" : 1/32, "Semifusa" : 1/64, "Quartifusa" : 1/128]
    
    @State private var Selected = ""
    @State private var animation = 0.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    var body: some View {
        VStack{
            //Área que vai recever conteúdo draggable
            Canvas { context, size in
                    }
                .overlay {
                    ZStack{
                        RoundedRectangle(cornerSize: CGSize(width: 50, height: 50))
                            .foregroundStyle(.black)
                            .frame(width: 300, height: 350)
                        VStack{
                            Text(Selected)
                                .font(.system(size: 40))
                                .foregroundStyle(.white)
                            Image("\(Selected)-Nota")
                            
                            //Define o valor para a progress view como 100, sempre que recebe
                            ProgressView(value: animation, total: 100.0)
                                .frame(width: 200)
                                .foregroundStyle(.green)
                                .onChange(of: soundManager.check2, initial: false) { _,_  in
                                    withAnimation(.linear(duration: 1)){
                                        if animation == 100.0{
                                            animation = 0.0
                                        }else{
                                            animation = 100.0
                                        }
                                    }
                                }
                        }
                    }
                    .dropDestination(for: String.self) { items, _ in
                        
                        print("Itens do drop: \(items)")
                        
                        let itemsSplit = items[0].components(separatedBy: ":")
                        
                        print(itemsSplit)
                        
                        Selected = itemsSplit.first ?? ""

                        soundManager.stopAll()
                        
                        soundManager.playLoop(sound: .beat, split: itemsSplit.last ?? "", tempo: "4/4", check: 0)
                        return true
                    }
                    .foregroundStyle(.black)
                }
            Spacer()
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
    ContentView()
}
