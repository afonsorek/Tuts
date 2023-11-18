//
//  LandscapeView.swift
//  BeatsTest
//
//  Created by Rafa (Ruffles) on 09/11/23.
//

import SwiftUI

struct LandscapeView: View {
    @ObservedObject var configController = ConfigController.shared
    @ObservedObject var timeController = TimeController.shared
    @ObservedObject var compassController : CompassController
    
    @State var isOnLoop = true
    @State var isOnShuffle = false
    
    var body: some View {
        ZStack{
            VStack(spacing: 13){
                HStack{
                    ZStack{
                        HStack(spacing: 1){
                            Text("\(compassController.compass.pulseCount)")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.white)
                            Text("/")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.white)
                            Text("\(compassController.compass.pulseDuration)")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.leading, 55)
                    Spacer()
                }
                BarView(compassController: compassController)
                
                HStack(spacing: 13){
                    HStack(alignment: .center, spacing: 13) {
                        Image(systemName: timeController.isPlaying ? "pause.fill" : "play.fill")
                            .font(.title)
                            .foregroundColor(timeController.isPlaying ? .white : Color(red: 0.28, green: 0.2, blue: 0.45))
                    }
                    .frame(width: 66, height: 55)
                    .background(timeController.isPlaying ? Color(red: 0.28, green: 0.2, blue: 0.45) : .white)
                    .cornerRadius(16)
                    .overlay(
                    RoundedRectangle(cornerRadius: 16)
                    .inset(by: 0.5)
                    .stroke(.white, lineWidth: timeController.isPlaying ? 2 : 0)
                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.7), radius: 4, y: 4)
                    )
                    .onTapGesture {
                        withAnimation(.linear(duration: 0.3)){
                            timeController.toggleTimer()
                        }
                        //LÓGICA DE PLAY E PAUSE
                    }
                    
                    HStack(alignment: .center, spacing: 13) {
                        Image(systemName: "infinity")
                            .font(.title)
                            .foregroundColor(isOnLoop ? Color(red: 0.28, green: 0.2, blue: 0.45) : .white)
                    }
                    .frame(width: 66, height: 55)
                    .background(isOnLoop ? .white : Color(red: 0.28, green: 0.2, blue: 0.45))
                    .cornerRadius(16)
                    .overlay(
                    RoundedRectangle(cornerRadius: 16)
                    .inset(by: 0.5)
                    .stroke(.white, lineWidth: isOnLoop ? 0 : 2)
                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.7), radius: 4, y: 4)
                    )
                    .onTapGesture {
                        withAnimation(.linear(duration: 0.3)){
                            isOnLoop.toggle()
                        }
                        //LÓGICA DE LOOP
                    }
                    
//                    HStack(alignment: .center, spacing: 13) {
//                        Image(systemName: "shuffle")
//                            .font(.title)
//                            .foregroundColor(isOnShuffle ? Color(red: 0.28, green: 0.2, blue: 0.45) : .white)
//                    }
//                    .frame(width: 66, height: 55)
//                    .background(isOnShuffle ? .white : Color(red: 0.28, green: 0.2, blue: 0.45))
//                    .cornerRadius(16)
//                    .overlay(
//                    RoundedRectangle(cornerRadius: 16)
//                    .inset(by: 0.5)
//                    .stroke(.white, lineWidth: isOnShuffle ? 0 : 2)
//                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.7), radius: 4, y: 4)
//                    )
//                    .onTapGesture {
//                        withAnimation(.linear(duration: 0.3)){
//                            isOnShuffle.toggle()
//                        }
//                        //LÓGICA DE SHUFFLE
//                    }
                    
                    Spacer()
                    
                    HStack(alignment: .center, spacing: 13) {
                        Image(systemName: "rectangle.landscape.rotate")
                            .font(.title)
                            .foregroundColor(configController.config.orientationLock ? Color(red: 0.28, green: 0.2, blue: 0.45) : .white)
                    }
                    .frame(width: 66, height: 55)
                    .background(configController.config.orientationLock ? .white : Color(red: 0.28, green: 0.2, blue: 0.45))
                    .cornerRadius(16)
                    .overlay(
                    RoundedRectangle(cornerRadius: 16)
                    .inset(by: 0.5)
                    .stroke(.white, lineWidth: configController.config.orientationLock ? 0 : 2)
                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.7), radius: 4, y: 4)
                    )
                    .onTapGesture {
                        withAnimation(.linear(duration: 0.3)){
                            configController.toggleOrientationLock()
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.horizontal, 35)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LandscapeView(compassController: CompassController())
}
