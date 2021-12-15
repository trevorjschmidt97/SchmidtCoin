//
//  ProfilePageView.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 11/29/21.
//

import SwiftUI

struct ProfilePageView: View {
    @ObservedObject var blockChain: BlockChain
    @StateObject var appViewModel = AppViewModel.shared
    var privateKey: String
    
    var body: some View {
        VStack {
            VStack {
                if let publicKey = Crypto.getPublicKeyString(forPrivateKeyString: privateKey) {
                    Text("@\(String(publicKey.prefix(22)))")
                    Text("\(String(publicKey.suffix(22)))")
                } else {
                    Text("@\(Crypto.getPublicKeyString(forPrivateKeyString: privateKey) ?? "")")
                }
            }
                .padding()
            
            // Balance
            Text("\(blockChain.getBalanceOfWallet(address: Crypto.getPublicKeyString(forPrivateKeyString: privateKey) ?? "").formatted())")
            Text("Schmidt Coin")
                .padding(.bottom, 10)
            
            List {
                if let pendingTransactions = blockChain.pendingTransactions(forPrivateKey: privateKey),
                   pendingTransactions.count > 0 {
                    Section("Pending Transactions") {
                        ForEach(pendingTransactions) { transaction in
                            TransactionView(transaction: transaction)
                        }
                    }
                }
                
                
                if let confirmedTransactions = blockChain.confirmedTransactions(forPrivateKey: privateKey), confirmedTransactions.count > 0 {
                    Section("Transactions") {
                        ForEach(confirmedTransactions) { transaction in
                            TransactionView(transaction: transaction)
                        }
                    }
                }
            }
            
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button("Sign Out") {
                    appViewModel.privateKey = nil
                }
            }
        }
    }
}
