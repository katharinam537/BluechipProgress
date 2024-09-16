//
//  LogInView.swift
//  BluechipProgress
//
//  Created by Danylo Klymenko on 12.09.2024.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var isAlertShown = false
    @State private var switcher = true
    
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                VStack {
                    
                    Image("pinkCrown")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .shadow(radius: 10)
                        .glow(.white.opacity(0.5), radius: 10)
                        .padding(.top)
                    
                    VStack(spacing: 18) {
                        InputView(text: $email,
                                  title: "Email",
                                  placeholder: "email@example.com")
                        .textInputAutocapitalization(.none)
                        
                        InputView(text: $password,
                                  title: "Password",
                                  placeholder: "Enter password",
                                  isSecure: true)
                        .textInputAutocapitalization(.none)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    
                    Button {
                        viewModel.email = email
                        Task {
                            try await viewModel.signIn(email: email, password: password)
                        }
                        withAnimation {
                            isAlertShown.toggle()
                        }
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.lightPink)
                                .frame(width: getScreenSize().width - 40, height: 70)
                                .cornerRadius(12)
                            
                            Text("LOG IN")
                                .foregroundStyle(.white)
                                .font(.system(size: 34, weight: .heavy, design: .serif))
                        }
                    }
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? 1 : 0.5 )
                    .padding(.top, 24)
                    
                    Button {
                        Task {
                             await viewModel.signInAnonymously()
                        }
                        withAnimation {
                            isAlertShown.toggle()
                        }
                    } label: {
                        Text("ANONYMOUS LOG IN")
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .heavy, design: .serif))
                    }
                    .padding(.top)
                    
                    Spacer()
                    
                    NavigationLink {
                        RegistrationView(viewModel: viewModel)
                            //.navigationBarBackButtonHidden()
                    } label: {
                        Text("YOU DON’T HAVE AN ACCOUNT YET? SIGN UP NOW")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .light, design: .serif))
                            .frame(width: 300)
                    }
                    .padding(.top)
                    .padding(.bottom, 70)

                }
            }
        }
        .tint(.white)
        .overlay {
            if isAlertShown {
                ProgressAlertView(text: "Incorrect email or password.", switcher: $switcher) {
                    withAnimation {
                        isAlertShown = false
                        switcher = true
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        switcher = false
                    }
                }
            }
        }
    }
}

extension LoginView: AuthViewModelProtocol {
    var isFormValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: AuthViewModel())
    }
}
