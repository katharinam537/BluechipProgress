//
//  TabMainView.swift
//  BCP
//
//  Created by Danylo Klymenko on 18.09.2024.
//

import SwiftUI

struct BottomCurve: Shape {

    var currentXValue: CGFloat
    
    var animatableData: CGFloat{
        get{currentXValue}
        set{currentXValue = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        
        return Path{path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            let mid = currentXValue
            path.move(to: CGPoint(x: mid - 50, y: 0))
            
            let to1 = CGPoint(x: mid, y: 35)
            let control1 = CGPoint(x: mid - 25, y: 0)
            let control2 = CGPoint(x: mid - 25, y: 35)
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            
            let to2 = CGPoint(x: mid + 50, y: 0)
            let control3 = CGPoint(x: mid + 25, y: 35)
            let control4 = CGPoint(x: mid + 25, y: 0)
            
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}


struct MaterialEffect: UIViewRepresentable {
    
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}


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
