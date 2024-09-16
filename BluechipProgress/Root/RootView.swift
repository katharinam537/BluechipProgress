//
//  RootView.swift
//  BluechipProgress
//
//  Created by Danylo Klymenko on 12.09.2024.
//

import SwiftUI

struct RootView: View {
    
    @StateObject private var viewModel = AuthViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                TabMainView()
                    .environmentObject(viewModel)
            } else {
                LoginView(viewModel: viewModel)
                  
            }
        }
        
    }
}

#Preview {
    RootView()
}
