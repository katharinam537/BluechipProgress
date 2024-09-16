//
//  GoalDetailView.swift
//  BluechipProgress
//
//  Created by Danylo Klymenko on 11.09.2024.
//

import SwiftUI

struct GoalDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    //@State var goal: Goal = Goal()
    @State var subs: [Subgoal] = []
    var goal: Goal
    var completion: () -> ()
    var onClosing: () -> ()
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.darkBlue)
                .ignoresSafeArea()
            
            VStack {
                Text(goal.mainGoalName)
                    .foregroundStyle(.white)
                    .font(.system(size: 22, weight: .bold))
                    .padding(.top, 10)
                    
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.lightPink.opacity(0.6))
                
                
                ScrollView {
                    
                    VStack {
                        ForEach(subs, id: \.id) { subgoal in
                            ZStack {
                                Rectangle()
                                    .frame(height: 60)
                                    .cornerRadius(12)
                                
                                HStack {
                                    Text(subgoal.name)
                                        .foregroundColor(.black)
                                        .padding(.leading)
                                    
                                    Spacer()
                                    
                                    Button {
                                        StorageManager.shared.markSubgoalAsComplete(subgoal: subgoal)
                                        subs = []
                                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                                            subs = Array(goal.subgoals)
                                        }
                                        completion()
                                    } label: {
                                        ZStack {
                                            Rectangle()
                                                .frame(width: 70, height: 40)
                                                .foregroundColor(.darkBlue)
                                                .cornerRadius(6)
                                            
                                            Text(subgoal.isCompleted ? "✅" : "☑️")
                                        }
                                    }
                                    .disabled(subgoal.isCompleted)
                                    .padding(.trailing)
                                }
                                
                                
                            }
                            .overlay {
                                if subgoal.isCompleted {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(.pink)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    
                    HStack {
                        Text("Deadline:")
                            .font(.system(size: 22, weight: .light))
                            .foregroundStyle(.gray)
                        
                        Spacer()
                    }
                    .padding(.top)
                    .padding(.leading)
                    
                    HStack {
                        Text("\(formattedDateString(from: goal.deadLine ?? Date()))")
                            .font(.system(size: 26, weight: .light))
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                    .padding(.leading)
                    
                    if !goal.note.isEmpty {
                        HStack {
                            Text("Note:")
                                .font(.system(size: 22, weight: .light))
                                .foregroundStyle(.gray)
                            
                            Spacer()
                        }
                        .padding(.leading)
                        .padding(.top)
                        
                        HStack {
                            Text("\(goal.note)")
                                .font(.system(size: 26, weight: .light))
                                .foregroundStyle(.white)
                            
                            Spacer()
                        }
                        .padding(.leading)
                    }
                    
                    if goal.imageData != nil {
                        HStack {
                            Text("Image:")
                                .font(.system(size: 22, weight: .light))
                                .foregroundStyle(.gray)
                            
                            Spacer()
                        }
                        .padding(.leading)
                        .padding(.top)
                       
                        if let imageData = goal.imageData, let image = UIImage(data: imageData) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: getScreenSize().width - 40, height: 400)
                                .cornerRadius(24)
                        }
                    }
                   
                    
                    Button {
                        StorageManager.shared.markGoalAsComplete(goal: goal)
                        completion()
                        onClosing()
                        dismiss()
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .frame(height: 70)
                            
                            Text("Complete Goal")
                                .font(.title)
                                .bold()
                                .foregroundStyle(.black)
                        }
                            
                    }
                    .padding(.bottom, 200)
                    .padding(.top)
                    .padding(.horizontal)
                }
                .scrollIndicators(.hidden)
                
            }
            .foregroundColor(.white)
        }
        .overlay(alignment: .leading) {
            VStack {
                Button {
                    onClosing()
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.title)
                }
                
                Spacer()
            }
            .padding(.top, 10)
            .padding(.leading)
        }
        .onAppear {
            subs = Array(goal.subgoals)
        }
    }
}
//
//#Preview {
//    GoalDetailView()
//}
