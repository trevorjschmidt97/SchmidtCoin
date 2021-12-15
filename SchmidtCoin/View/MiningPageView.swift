//
//  MiningPageView.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 11/29/21.
//

import SwiftUI

struct MiningPageView: View {
    @ObservedObject var blockChain: BlockChain
    @StateObject var appViewModel = AppViewModel.shared
    var privateKey: String
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader { reader in
                        HStack {
                            ForEach(blockChain.chain) { block in
                                BlockView(block: block)
                            }
                                .onAppear {
                                    if let latestBlock = blockChain.latestBlock() {
                                        reader.scrollTo(latestBlock.id, anchor: .center)
                                    }
                                }
                        }
                            .padding()
                    }
                }
                Section("Pending Transactions") {
                    ForEach(Array(blockChain.pendingTransactions.values)) { pendingTransaction in
                        TransactionView(transaction: pendingTransaction)
                    }
                }
            }
            .navigationTitle("BlockChain")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if blockChain.isMining {
                        Button("Stop Mining") {
                            blockChain.isMining = false
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if blockChain.isMining {
                        ProgressView()
                    } else {
                        Button("Mine") {
                            if let publicKey = Crypto.getPublicKeyString(forPrivateKeyString: privateKey) {
                                blockChain.minePendingTransactions(miningRewardPublicKey: publicKey)
                            }
                        }
                    }
                }
            }
        }
    }
}

//struct MiningView_Previews: PreviewProvider {
//    static var previews: some View {
//        MiningPageView()
//    }
//}
