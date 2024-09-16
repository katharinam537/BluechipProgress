//
//  SubgoalsView.swift
//  BluechipProgress
//
//  Created by Danylo Klymenko on 10.09.2024.
//

import SwiftUI

struct SubgoalsView: View {
    
    var subgoals: [Subgoal]
    @State var subs: [Subgoal] = []
    @Binding var counter: Int
    
    var body: some View {
        HStack {
            Text("\(counter)")
                .font(.system(size: 1))
                .foregroundColor(.darkBlue)
            
            ForEach(Array(subgoals.enumerated()), id: \.offset) { index, subgoal in
                HStack(spacing: 0) {
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(subgoal.isCompleted ? .green : .white)
                    Circle()
                        .frame(height: 20)
                        .foregroundColor(subgoal.isCompleted ? .green : .white)
                }
                .padding(.leading, -9)
            }
            
        }
        .onAppear {
            subs = []
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                subs = subgoals
            }
        }
        .frame(width: getScreenSize().width - 100, height: 2)
        .padding(.top, 25)
    }
}


