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
    
    @State var reloaded = true
    
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
                if reloaded{
                    BarView(compassController: compassController)
                }else{
                    BarView(compassController: CompassController())
                }
                
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
                    }
                    
                    HStack(alignment: .center, spacing: 13) {
                        Image(systemName: "infinity")
                            .font(.title)
                            .foregroundColor(configController.config.loopCompass ? Color(red: 0.28, green: 0.2, blue: 0.45) : .white)
                    }
                    .frame(width: 66, height: 55)
                    .background(configController.config.loopCompass ? .white : Color(red: 0.28, green: 0.2, blue: 0.45))
                    .cornerRadius(16)
                    .overlay(
                    RoundedRectangle(cornerRadius: 16)
                    .inset(by: 0.5)
                    .stroke(.white, lineWidth: configController.config.loopCompass ? 0 : 2)
                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.7), radius: 4, y: 4)
                    )
                    .onTapGesture {
                        withAnimation(.linear(duration: 0.3)){
                            configController.toggleLoopCompass()
                        }
                    }
                    
                    HStack(alignment: .center, spacing: 13) {
                        Image(systemName: "gift.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .frame(width: 66, height: 55)
                    .background(Color(red: 0.28, green: 0.2, blue: 0.45))
                    .cornerRadius(16)
                    .overlay(
                    RoundedRectangle(cornerRadius: 16)
                    .inset(by: 0.5)
                    .stroke(.white, lineWidth: 2)
                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.7), radius: 4, y: 4)
                    )
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.1)){
                            reloaded = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            compassController.random()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeIn(duration: 0.2)){
                                reloaded = true
                            }
                        }
                    }
                    
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
