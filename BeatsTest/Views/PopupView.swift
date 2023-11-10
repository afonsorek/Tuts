//
//  PopupView.swift
//  BeatsTest
//
//  Created by Afonso Rekbaim on 10/11/23.
//

import SwiftUI

struct PopupView: View {
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                Rectangle()
                    .frame(height: 1)
                HStack{
                    Button("Cancelar"){
                        
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.plain)
                    Rectangle()
                        .frame(width: 1)
                    Button("Concluido"){
                        
                    }
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 14, height: 14)))
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.plain)
                }
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 14, height: 14)))
                .frame(height: 44)
            }
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 14, height: 14)))
            .frame(width: 332, height: 292)
        }.background(.black)
    }
}

#Preview {
    PopupView()
}
