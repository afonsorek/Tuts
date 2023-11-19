//
//  ConfigView.swift
//  BeatsTest
//
//  Created by Afonso Rekbaim on 17/11/23.
//

import SwiftUI

struct ConfigView: View {
    
    @ObservedObject var configController = ConfigController.shared
    
    @Binding var mostrandoTela: Int
    
    var body: some View {
        ZStack{
            VStack(spacing: 25){
                HStack{
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut){
                            mostrandoTela = 0
                        }
                    }, label: {
                        HStack{
                            Text("Voltar")
                                .font(
                                Font.custom("SF Pro Text", size: 17)
                                .weight(.semibold)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                            
                            Image(systemName: "chevron.right")
                                .font(
                                Font.custom("SF Pro Text", size: 20)
                                .weight(.semibold)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 32)
                    })
                }
                                
                ZStack{
                    VStack{
                        // Title 3
                        Text("Visualização:")
                            .fontWeight(.heavy)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 289, height: 26, alignment: .topLeading)
                            .padding(.bottom, 15)
                        
                        HStack{
                            Toggle(isOn: configController.showBeatsBinding, label: {
                                VStack{
                                    Text("Círculos/Batidas")
                                      .font(Font.custom("SF Pro", size: 17))
                                      .foregroundColor(.white)
                                      .frame(width: 145, height: 16, alignment: .topLeading)
                                }
                            })
                        }
                        .frame(width: 289)
                        
                        Divider()
                            .overlay(.white)
                            .frame(width: 289)
                            .padding(.vertical, 10)
                        
                        HStack{
                            Toggle(isOn: configController.noteColorsBinding, label: {
                                Text("Cores")
                                  .font(Font.custom("SF Pro", size: 17))
                                  .foregroundColor(.white)
                                  .frame(width: 145, height: 16, alignment: .topLeading)
                            })
                        }
                        .frame(width: 289)
                        
                        Divider()
                            .overlay(.white)
                            .frame(width: 289)
                            .padding(.vertical, 10)
                        
                        HStack{
                            Toggle(isOn: configController.colorblindAccessibilityBinding, label: {
                                Text("Daltonismo")
                                  .font(Font.custom("SF Pro", size: 17))
                                  .foregroundColor(.white)
                                  .frame(width: 145, height: 16, alignment: .topLeading)
                            })
                        }
                        .frame(width: 289)
                        
                        Divider()
                            .overlay(.white)
                            .frame(width: 289)
                            .padding(.vertical, 10)
                        
                        HStack{
                            Toggle(isOn: configController.metronomeActiveBinding, label: {
                                Text("Metrônomo")
                                  .font(Font.custom("SF Pro", size: 17))
                                  .foregroundColor(.white)
                                  .frame(width: 145, height: 16, alignment: .topLeading)
                            })
                        }
                        .frame(width: 289)
                        
                        Spacer()
                    }
                }
                .padding(.top, 28)
                .foregroundColor(.clear)
                .frame(width: 358, height: 348)
                .background(.white.opacity(0.1))
                .cornerRadius(16)
                
                Spacer()
            }
            .padding(.vertical, 25)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
        LinearGradient(
        stops: [
        Gradient.Stop(color: Color(red: 0.28, green: 0.2, blue: 0.45), location: 0.00),
        Gradient.Stop(color: Color(red: 0.16, green: 0.11, blue: 0.26), location: 1.00),
        ],
        startPoint: UnitPoint(x: 0.5, y: 0),
        endPoint: UnitPoint(x: 0.5, y: 1)
        )
        )
    }
}

#Preview {
    ConfigView(mostrandoTela: .constant(0))
}
