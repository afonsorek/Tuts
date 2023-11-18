//
//  Onboarding2.swift
//  BeatsTest
//
//  Created by Afonso Rekbaim on 18/11/23.
//

import SwiftUI

struct Onboarding2: View {
    @Binding var selected : Int
    
    var body: some View {
        ZStack{
            Image("onboarding2")
                .resizable()
                .scaleEffect(1.01)
            
            VStack{
                Spacer()
                Button(action: {
                    withAnimation{
                        selected = 2
                    }
                }, label: {
                    VStack(alignment: .center, spacing: 0) {
                        Text("Próximo!")
                          .font(
                            Font.custom("SF Pro", size: 20)
                              .weight(.semibold)
                          )
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color(red: 0.28, green: 0.2, blue: 0.45))
                          .frame(maxWidth: .infinity, alignment: .top)
                    }
                    .padding(16)
                    .frame(width: 350, alignment: .center)
                    .background(.white)
                    .cornerRadius(8)
                })
            }
            .padding(.bottom, 40)
        }
        .onAppear{
            RotationController.forceScreenOrientation(orientation: .portrait)
        }
        .onRotate{ _ in
            RotationController.forceScreenOrientation(orientation: .portrait)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Onboarding2(selected: .constant(0))
}
