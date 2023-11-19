//
//  Onboarding4.swift
//  BeatsTest
//
//  Created by Afonso Rekbaim on 18/11/23.
//

import SwiftUI

struct Onboarding4: View {
    @Binding var showOnboarding : Bool
    
    @ObservedObject var configController = ConfigController.shared
    
    @State private var orientation = UIDeviceOrientation.unknown

    var body: some View {
        ZStack{
            Image("onboarding4")
                .resizable()
                .scaleEffect(1.01)
            
            HStack{
                Button(action: {
                    showOnboarding.toggle()
                }, label: {
                    HStack(alignment: .center, spacing: 0) {
                        // Title3/Emphasized
                        Text("Vamos lá!")
                          .font(
                            Font.custom("SF Pro", size: 20)
                              .weight(.semibold)
                          )
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color(red: 0.28, green: 0.2, blue: 0.45))
                          .frame(maxWidth: .infinity, alignment: .top)
                    }
                    .padding(16)
                    .frame(width: 150, alignment: .center)
                    .background(.white)
                    .cornerRadius(8)
                    .padding(.leading, 580)
                })
            }
            .padding(.top, 250)
                
        }
        .onRotate { newOrientation in
            if configController.config.orientationLock {
                RotationController.forceScreenOrientation()
            }
            if RotationController.isValidOrientation(orientation: newOrientation) {
                orientation = newOrientation
            }
            RotationController.shared.updateScreenRect()
        }
        .onAppear{
            orientation = RotationController.isValidOrientation() ? UIDevice.current.orientation : .portrait
        }
        .onAppear{
            configController.toggleOrientationLock()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Onboarding4(showOnboarding: .constant(true))
}
