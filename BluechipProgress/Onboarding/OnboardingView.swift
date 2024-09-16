//
//  OnboardingView.swift
//  BluechipProgress
//
//  Created by Danylo Klymenko on 12.09.2024.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            BackgroundView()
         
            Rectangle()
                .foregroundColor(.black.opacity(0.6))
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    Text("Welcome to the BLUECHIP PROGRESS!")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .multilineTextAlignment(.center)
                    
                    Image("pinkCrown")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .blur(radius: 0.2)
                        .glow(.gray.opacity(0.5), radius: 10)
                    
                    Text("Start turning your dreams into actionable goals. With our app, you can set personal or professional goals, break them down into smaller, manageable sub-goals, and track your progress step by step.")
                        .font(.system(size: 24, weight: .thin, design: .serif))
                        .padding(.horizontal)
                        .padding(.top)
                    
                    Text("""
    Here’s how it works:

    1. Set Your Goals – Define what you want to achieve, big or small.
    2. Break It Down – Split your goals into sub-goals to make the journey easier.
    3. Track Progress – Mark your sub-goals as completed and watch your progress grow.
    4. Stay on Course – Stay motivated as you move closer to achieving your dreams.
    """)
                    .font(.system(size: 24, weight: .thin, design: .serif))
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Button {
                        dismiss()
                    } label: {
                        ZStack {
                            Text("Ready to take the first step? Let’s get started!")
                                .foregroundStyle(.black)
                                .font(.system(size: 24, weight: .thin, design: .serif))
                                .multilineTextAlignment(.center)
                                .padding()
                                .background {
                                    Rectangle()
                                        .frame(height: 100)
                                        .cornerRadius(12)
                                }
                        }
                    }
                    .padding()
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, 100)
                }
                .foregroundColor(.white)
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    OnboardingView()
}
