//
//  Back.swift
//  BCP
//
//  Created by Danylo Klymenko on 18.09.2024.
//

import SwiftUI
import FoggyColors

struct BackgroundView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.darkBlue)
            
            FoggyColorsView(
                blurRadius: 96,
                globalOpacity: 1.6,
                elementOpacity: 1.4,
                animated: true,
                numberShapes: 20
            )
        }
        .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}
