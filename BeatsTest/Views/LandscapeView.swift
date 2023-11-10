//
//  LandscapeView.swift
//  BeatsTest
//
//  Created by Rafa (Ruffles) on 09/11/23.
//

import SwiftUI

struct LandscapeView: View {
    @ObservedObject var compassController : CompassController
    
    var body: some View {
        ZStack{
            BarView(compassController: compassController)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    
}

#Preview {
    LandscapeView(compassController: CompassController())
}
