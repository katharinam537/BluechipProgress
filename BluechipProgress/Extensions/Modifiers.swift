//
//  Modifiers.swift
//  BluechipProgress
//
//  Created by Danylo Klymenko on 05.09.2024.
//

import SwiftUI

struct RotatableModifier: ViewModifier {
    @State private var translation: CGSize = .zero
    @State private var isDragging = false

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(isDragging ? 10 : 0),
                axis: (x: -translation.height, y: translation.width, z: 0)
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        translation = value.translation
                        isDragging = true
                    }
                    .onEnded { _ in
                        withAnimation {
                            translation = .zero
                            isDragging = false
                        }
                    }
            )
    }
}

extension View {
    func rotatable() -> some View {
        self.modifier(RotatableModifier())
    }
}
