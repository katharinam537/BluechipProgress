//
//  NewGoalView.swift
//  BluechipProgress
//
//  Created by Danylo Klymenko on 10.09.2024.
//

import SwiftUI

struct NewGoalView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var goalName = ""
    @State var deadline = Date()
    @State var image: UIImage?
    @State var note = ""
    
    @State var isMainGoal = false
    
    @State var subgoals: [Subgoal] = []
    @State var subgoalName = ""
    
    @State var isPickerShown: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.darkBlue)
                .ignoresSafeArea()
            
            VStack {
                Text("New Goal")
                    .foregroundStyle(.white)
                    .font(.system(size: 32, weight: .bold, design: .serif))
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.lightPink.opacity(0.6))
                
                ScrollView {
                    
                    Text("Goal name:")
                        .foregroundStyle(.white)
                        .frame(width: getScreenSize().width - 40, alignment: .leading)
                        .padding(.top)
                    
                    TextField("Do something cool...", text: $goalName)
                        .foregroundColor(.black)
                        .padding()
                        .background {
                            Color.white
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                
                    Text("Note:")
                        .foregroundStyle(.white)
                        .frame(width: getScreenSize().width - 40, alignment: .leading)
                        .padding(.top)
                    
                    TextEditor(text: $note)
                        .foregroundStyle(.black)
                        .padding(.horizontal)
                        .frame(height: 200)
                        .background(Color.white.cornerRadius(12))
                        .tint(.black)
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal)
                    
                    HStack {
                        Text("Main Goal")
                            .foregroundStyle(.white)
                        
                        Toggle("", isOn: $isMainGoal)
                        
                       
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    
                    DatePicker(selection: $deadline, in: deadline..., displayedComponents: .date) {
                        Text("Select deadline")
                    }
                    .tint(.lightPink.opacity(0.6))
                    .datePickerStyle(.compact)
                    .colorMultiply(.white)
                    .environment(\.colorScheme, .dark)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: getScreenSize().width - 60, height: 250)
                            .scaledToFit()
                            .cornerRadius(12)
                            .padding(.top)
                        
                    } else {
                        HStack {
                            Text("Add image")
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Button {
                                isPickerShown.toggle()
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 120, height: 35)
                                        .cornerRadius(6)
                                        .foregroundColor(.gray.opacity(0.2))
                                    
                                    HStack {
                                        Image(systemName: "camera")
                                           
                                        
                                        Text("/")
                                        
                                        Image(systemName: "photo.artframe")
                                    }
                                    .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.top)
                        .padding(.horizontal)
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.lightPink.opacity(0.6))
                        .padding(.vertical)
                    
                    Text("Add subgoal:")
                        .foregroundStyle(.white)
                        .frame(width: getScreenSize().width - 40, alignment: .leading)
                    
                    HStack {
                        
                        TextField("Do something cool...", text: $subgoalName)
                            .foregroundColor(.black)
                            .padding()
                            .background {
                                Color.white
                                    .cornerRadius(12)
                            }
                            .padding(.leading)
                        
                        Spacer()
                        
                        Button {
                            if !subgoalName.isEmpty {
                                let sub = Subgoal()
                                sub.name = subgoalName
                                subgoals.append(sub)
                                subgoalName = ""
                            }
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 50)
                        .padding(.trailing)
                    }
                    
                    if !subgoals.isEmpty {
                        Text("Subgoals:")
                            .foregroundStyle(.white)
                            .frame(width: getScreenSize().width - 40, alignment: .leading)
                            .padding(.top)
                        
                        ForEach(subgoals, id: \.id) { subgoal in
                            ZStack {
                                Rectangle()
                                    .frame(width: getScreenSize().width - 40, height: 60)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                
                                Text(subgoal.name)
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                    
                    Button {
                        if !goalName.isEmpty {
                            StorageManager.shared.saveGoal(goal: prepareGoal())
                            dismiss()
                        }
                    } label: {
                        ZStack {
                            Rectangle()
                                .fill(LinearGradient(colors: [.red, .blue], startPoint: .bottomLeading, endPoint: .topTrailing))
                                .frame(width: 300, height: 70)
                                .cornerRadius(12)
                            
                            Text("Save Goal")
                                .font(.system(size: 22, weight: .regular, design: .serif))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.top, 40)
                }
                .scrollIndicators(.hidden)
                .padding(.top, -5)
            }
            
        }
        .overlay(alignment: .leading) {
            VStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $isPickerShown) {
            ZStack {
                Rectangle()
                    .foregroundColor(.darkBlue)
                
                ImageSelectionView(selectedImage: $image) {
                    withAnimation {
                        isPickerShown = false
                    }
                } closing: {
                    isPickerShown = false
                }
                
            }
            .presentationDetents([.height(150)])
        }
    }
    
    func prepareGoal() -> Goal {
        let newGoal = Goal()
        
        newGoal.mainGoalName = goalName
        newGoal.note = note
        newGoal.deadLine = deadline
        
        if let image = image {
            newGoal.imageData = image.jpegData(compressionQuality: 1.0)
        }
        if isMainGoal {
            StorageManager.shared.resetAllMainGoals()
        }
        
        newGoal.isMainGoal = isMainGoal
        
        
        for sub in subgoals {
            newGoal.subgoals.append(sub)
        }
        
        return newGoal
    }
    
}

#Preview {
    NewGoalView()
}
