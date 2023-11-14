//
//  PopupView.swift
//  BeatsTest
//
//  Created by Afonso Rekbaim on 10/11/23.
//

import SwiftUI

struct PopupView: View {
    @ObservedObject var compassController : CompassController
    @ObservedObject var timeController = TimeController.shared
    
    @State var editing : String
    
    @Binding var isPopupVisible: Bool
    
    var body: some View {
        ZStack{
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(Color(red: 0.28, green: 0.2, blue: 0.45, opacity: 0.5))
                .onTapGesture {
                    withAnimation(.linear(duration: 0.3)){
                        isPopupVisible = false
                    }
                }
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .frame(width: 332, height: 292)
                .overlay(
                    VStack(spacing: 0){
                        Spacer()
                        if editing == "compass"{
                            HStack{
                                Picker("", selection: compassController.pulseCountBinding) {
                                    ForEach(1...32, id: \.self) {
                                        Text("\($0)")
                                    }
                                }
                                .pickerStyle(.wheel)
                                .foregroundStyle(Color(red: 0.28, green: 0.2, blue: 0.45))
                                Text("/")
                                Picker("", selection: compassController.pulseDurationBinding) {
                                    ForEach(compassController.pulseDurationsValues, id: \.self) { value in
                                        Text("\(value)")
                                    }
                                }
                                .pickerStyle(.wheel)
                                .foregroundStyle(Color(red: 0.28, green: 0.2, blue: 0.45))
                            }
                        }else{
                            Picker("", selection: timeController.bpmBinding) {
                                ForEach(20...400, id: \.self) { value in
                                    Text("\(value)")
                                }
                            }
                            .pickerStyle(.wheel)
                            .foregroundStyle(Color(red: 0.28, green: 0.2, blue: 0.45))
                        }
                        Spacer()
                        Rectangle()
                            .frame(height: 1)
                            .padding(0)
                        HStack{
//                            Button("Cancelar") {
//                                // Ação para o botão Cancelar
//                            }
//                            .frame(maxWidth: .infinity)
//                            .buttonStyle(.plain)
//
//                            Rectangle()
//                                .frame(maxHeight: .infinity)
//                                .frame(width: 1)

                            Button("Concluido") {
                                withAnimation(.linear(duration: 0.3)){
                                    isPopupVisible = false
                                }
                            }
                            .bold()
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 14, height: 14)))
                            .frame(maxWidth: .infinity)
                            .buttonStyle(.plain)
                        }
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 14, height: 14)))
                        .frame(height: 44)
                        .padding(0)
                    }
                )
        }
        .ignoresSafeArea()
        .background(.clear)
    }
}


