//
//  TabMainView.swift
//  BluechipProgress
//
//  Created by Danylo Klymenko on 03.09.2024.
//

import SwiftUI

enum Tab: String,CaseIterable{
    case Home = "crown.fill"
    case GoalToComplete = "rectangle.grid.1x2.fill"
    case CompletedGoals = "trophy.fill"
    case Account = "person.fill"
}

struct TabMainView: View {
    
    @State var isTabBarShown = true
    @State var currentTab: Tab = .Home
    @EnvironmentObject var authViewModel: AuthViewModel
    
    init(){
        UITabBar.appearance().isHidden = true
    }
    
    @Namespace var animation
    
    @State var currentXValue: CGFloat = 0
    
    var body: some View {
        
        TabView(selection: $currentTab) {
            
           MainView()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .tag(Tab.Home)
            
            GoalListView() {
                isTabBarShown.toggle()
            }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .tag(Tab.GoalToComplete)
            
            CompletedGoalsView()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .tag(Tab.CompletedGoals)
            
            ProfileView()
                .environmentObject(authViewModel)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .tag(Tab.Account)
        }
        .overlay(alignment: .bottom) {
            if isTabBarShown {
                HStack(spacing: 0){
                    ForEach(Tab.allCases,id: \.rawValue){tab in
                        TabButton(tab: tab)
                    }
                }
                .padding(.vertical)
                .padding(.bottom,getSafeArea().bottom == 0 ? 10 : (getSafeArea().bottom - 10))
                .background(
                    MaterialEffect(style: .systemUltraThinMaterialDark)
                        .clipShape(BottomCurve(currentXValue: currentXValue))
                )
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    func TabButton(tab: Tab)->some View{
        
        GeometryReader{proxy in
            
            Button {
                withAnimation(.spring()){
                    currentTab = tab
                    currentXValue = proxy.frame(in: .global).midX
                }
                
            } label: {
                Image(systemName: tab.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(currentTab == tab ? 15 : 0)
                    .background(
                        ZStack{
                            if currentTab == tab{
                                MaterialEffect(style: .systemChromeMaterialDark)
                                    .clipShape(Circle())
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                        }
                    )
                    .contentShape(Rectangle())
                    .offset(y: currentTab == tab ? -50 : 0)
            }
            .onAppear {
                if tab == Tab.allCases.first && currentXValue == 0 {
                    currentXValue = proxy.frame(in: .global).midX
                }
            }
        }
        .frame(height: 30)
    }
}

#Preview {
    TabMainView()
        .environmentObject(AuthViewModel())
}
