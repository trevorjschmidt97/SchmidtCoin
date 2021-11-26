//
//  SchmidtCoinApp.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 9/29/21.
//

import SwiftUI

@main
struct SchmidtCoinApp: App {
    @StateObject var viewModel = AppViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}