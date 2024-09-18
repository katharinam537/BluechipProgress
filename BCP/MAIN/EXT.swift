//
//  EXT.swift
//  BCP
//
//  Created by Danylo Klymenko on 18.09.2024.
//

import SwiftUI

extension Color {
    
    static let darkBlue = Color(#colorLiteral(red: 0.01176470588, green: 0.09803921569, blue: 0.2274509804, alpha: 1))
    static let semiBlue = Color(#colorLiteral(red: 0.01176470588, green: 0.09803921569, blue: 0.3880324005, alpha: 1))
    static let lightBlue = Color(#colorLiteral(red: 0.2078431373, green: 0.3333333333, blue: 1, alpha: 1))
    static let lightPink = Color(#colorLiteral(red: 1, green: 0.03529411765, blue: 0.3764705882, alpha: 1))

}

extension View{
    
    func getSafeArea()->UIEdgeInsets{
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return .zero
        }
        
        return safeArea
    }
    
    func getScreenSize() -> CGSize {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        return window.screen.bounds.size
    }
    
    func glow(_ color: Color, radius: CGFloat) -> some View {
        self
            .shadow(color: color, radius: radius / 2.5)
            .shadow(color: color, radius: radius / 2.5)
            .shadow(color: color, radius: radius / 2.5)
    }
    
    func formattedDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    func randomColor() -> Color {
        return Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}


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
