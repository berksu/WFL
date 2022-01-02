//
//  MainBacnkground.swift
//  WFL
//
//  Created by Berksu Kısmet on 2.01.2022.
//

import SwiftUI

struct MainBackground: View {
    @State var selectedView = 1

    var body: some View {
        NavigationView{
            TabView(selection: $selectedView){
                MovieListView()
                    .tabItem {
                        Label("Movies", systemImage: "list.dash")
                    }
                    .tag(1)
                WordCardMenuView()
                    .tabItem {
                        Label("Cards", systemImage: "square.on.square")
                    }
                    .tag(2)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            UITabBar.appearance().backgroundColor = .black
            UITabBar.appearance().unselectedItemTintColor = UIColor(Colors().tabItemNotTappedYellow)
        }
        .accentColor(Colors().tabItemTappedYellow)
        
    }
}

struct MainBackground_Previews: PreviewProvider {
    static var previews: some View {
        MainBackground()
    }
}
