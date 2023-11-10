//
//  CircleView.swift
//  BeatsTest
//
//  Created by Afonso Rekbaim on 09/11/23.
//

import SwiftUI

struct CircleView: View {
    let id: UUID
    let duration: Double
    let screenSize: CGRect
    @State var animationProgress = 0.0
    
    init(duration: Double) {
        self.id = UUID()
        self.duration = duration
        self.screenSize = UIScreen.main.bounds
    }
    
    var body: some View {
        ZStack(){
            HStack{
                if duration == 0.5{
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                        .frame(width: 10)
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                        .frame(width: 10)
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                        .frame(width: 10)
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                        .frame(width: 10)
                }
            }
            Circle()
                .frame(width: 10)
                .foregroundColor(.black)
                .offset(x: animationProgress)
                .onAppear {
                    animationProgress = screenSize.width*0.05*(4.0*duration)/4.0
                    // Start the animation when the view appears
                    withAnimation(Animation.linear(duration: 4*duration).repeatForever(autoreverses: false)) {
                        animationProgress = screenSize.width*0.7*(Double(4) * duration)/Double(4)
                    }
                }
        }
    }
}

#Preview {
    CircleView(duration: 1.0)
}
