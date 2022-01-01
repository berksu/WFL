//
//  WFLApp.swift
//  WFL
//
//  Created by Berksu Kısmet on 20.12.2021.
//

import SwiftUI
import Firebase

@main
struct WFLApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MoviePlayerView()
            //WordCardMenuView()
        }
    }
}
