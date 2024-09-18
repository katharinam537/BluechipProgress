//
//  IMageSelection.swift
//  BCP
//
//  Created by Danylo Klymenko on 18.09.2024.
//

import SwiftUI

struct ImageSelectionView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var showCamera = false
    @State private var showPicker = false
    
    @Binding var selectedImage: UIImage?
    
    var completion: () -> ()
    var closing: () -> ()
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.darkBlue.opacity(0.01))
                .onTapGesture {
                    dismiss()
                    closing()
                }
                .overlay {
                    VStack {
                        Spacer()
                        ZStack {
                            Rectangle()
                                .foregroundColor(.darkBlue)
                                .frame(height: 200)
                                .cornerRadius(12)
                                .shadow(color: .white.opacity(0.5), radius: 1)
                                .overlay {
                                    VStack {
                                        Capsule()
                                            .frame(width: 60, height: 10)
                                            .foregroundColor(.white.opacity(0.1))
                                            .padding(.top, 10)
                                        Spacer()
                                    }
                                    
                                }
                            
                            HStack {
                                Button {
                                    showCamera.toggle()
                                } label: {
                                    Rectangle()
                                        .foregroundColor(.gray.opacity(0.5))
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(12)
                                        .overlay {
                                            VStack {
                                                Image(systemName: "camera")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 30, height: 30)
                                                    .padding(.bottom, 10)
                                                Text("Camera")
                                            }
                                            
                                        }
                                }
                                
                                Button {
                                    showPicker.toggle()
                                } label: {
                                    Rectangle()
                                        .foregroundColor(.gray.opacity(0.5))
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(12)
                                        .overlay {
                                            VStack {
                                                Image(systemName: "photo.on.rectangle.angled")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 30, height: 30)
                                                    .padding(.bottom, 10)
                                                Text("Library")
                                            }
                                        }
                                }
                            }
                            .tint(.white)
                        }
                    }
                }
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
                .onDisappear {
                    if let _ = selectedImage {
                        completion()
                    }
                }
                .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}
