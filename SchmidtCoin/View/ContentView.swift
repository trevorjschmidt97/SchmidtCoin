//
//  ContentView.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 9/29/21.
//

import SwiftUI


struct ContentView: View {
    @StateObject var appViewModel = AppViewModel.shared
    @StateObject private var blockChain = BlockChain()
    
    var body: some View {
        if let privateKey = appViewModel.privateKey {
            
            TabView {
                NavigationView {
                    TransactionPageView(blockChain: blockChain, privateKey: privateKey)
                }
                    .tabItem {
                        VStack {
                            Text("Transactions")
                            Image(systemName: "line.3.horizontal")
                        }
                    }
                
                MiningPageView(blockChain: blockChain, privateKey: privateKey)
                    .tabItem {
                        VStack {
                            Text("Mining")
                            Image(systemName: "lock.square.stack")
                        }
                    }
                
                ProfilePageView(blockChain: blockChain, privateKey: privateKey)
                    .tabItem {
                        VStack {
                            Text("Profile")
                            Image(systemName: "person.fill")
                        }
                    }
                
            }
            .onAppear {
                blockChain.onAppear()
            }
        } else {
            NavigationView {
                SignUpPageView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
