//
//  SchmidtCoinApp.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 9/29/21.
//

import SwiftUI
import Firebase

@main
struct SchmidtCoinApp: App {
    @StateObject var viewModel = AppViewModel.shared
    
    init() {
        FirebaseApp.configure()
        UITabBar.appearance().backgroundColor = .systemBackground
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    viewModel.checkSignIn()
                }
        }
    }
}
