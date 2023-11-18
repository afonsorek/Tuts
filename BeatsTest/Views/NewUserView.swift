//
//  NewUserView.swift
//  BeatsTest
//
//  Created by Afonso Rekbaim on 18/11/23.
//

import SwiftUI

struct NewUserView: View {
    @Binding var showOnboarding : Bool

    @State var selected = 0
    
    var body: some View {
        Group{
            if selected != 3{
                TabView(selection: $selected){
                    Onboarding1(selected: $selected)
                        .tag(0)
                    Onboarding2(selected: $selected)
                        .tag(1)
                    Onboarding3(selected: $selected)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
                .ignoresSafeArea()
            }else{
                Onboarding4(showOnboarding: $showOnboarding)
            }
        }
    }
}

#Preview {
    NewUserView(showOnboarding: .constant(true))
}
