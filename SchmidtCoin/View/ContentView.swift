//
//  ContentView.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 9/29/21.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var appViewModel = AppViewModel.shared
    @StateObject private var blockChain = BlockChain()
    let keypair1 = Crypto.genKeyPair()
    let keypair2 = Crypto.genKeyPair()
    
    var body: some View {
        List {
            Section("Pending Transactions") {
                ForEach(Array(blockChain.pendingTransactions.values)) { pendingTransaction in
                    Text("\(pendingTransaction.toString())")
                }
            }
            Section("Blocks") {
                ForEach(blockChain.chain, id: \.index) { block in
                    Text("\(block.toString())")
                }
            }
        }
        HStack {
            Button("Start Mining") {
                blockChain.minePendingTransactions(miningRewardWallet: keypair1.publicKey)
                print(blockChain.toString())
            }
        }
            .padding()
            .onAppear {
                blockChain.minePendingTransactions(miningRewardWallet: keypair1.publicKey)
                blockChain.addPendingTransaction(Transaction(fromPrivateKey: keypair1, toAddress: keypair2.publicKey, amount: 5, comments: "Hey"))
                blockChain.addPendingTransaction(Transaction(fromPrivateKey: keypair1, toAddress: keypair2.publicKey, amount: 5, comments: "number 2"))
//                blockChain.minePendingTransactions(miningRewardWallet: keypair2.publicKey)
//                blockChain.minePendingTransactions(miningRewardWallet: keypair1.publicKey)
//                print(blockChain.toString())
                print("This block chain is\(blockChain.isChainValid() ? "" : "NOT") valid")
                print("keypair1 balance: \(blockChain.getBalanceOfWallet(address: keypair1.publicKey))")
                print("keypair2 balance: \(blockChain.getBalanceOfWallet(address: keypair2.publicKey))")
            }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
