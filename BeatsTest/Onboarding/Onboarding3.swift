//
//  Onboarding3.swift
//  BeatsTest
//
//  Created by Afonso Rekbaim on 18/11/23.
//

import SwiftUI

struct Onboarding3: View {
    @Binding var selected : Int
        
    var body: some View {
        ZStack{
            Image("onboarding3")
                .resizable()
                .scaleEffect(1.01)
        }
        .onRotate(perform: { new in
            if selected == 2 && (new == .landscapeRight || new == .landscapeLeft){
                selected = 3
            }
        })
        .ignoresSafeArea()
    }
}

#Preview {
    Onboarding3(selected: .constant(0))
}
