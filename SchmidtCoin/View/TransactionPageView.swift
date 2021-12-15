//
//  TransactionPageView.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 11/29/21.
//

import SwiftUI

struct TransactionPageView: View {
    @ObservedObject var blockChain: BlockChain
    @StateObject var appViewModel = AppViewModel.shared
    var privateKey: String
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            List {
                ForEach(blockChain.publishedTransactions) { transaction in
                    BasicTransactionView(transaction: transaction)
//                    TransactionView(transaction: transaction)
                }
            }
            VStack {
                Spacer()
                Button {
                    let transaction = Transaction(fromPrivateKey: privateKey,
                                                  toAddress: Crypto.generatePrivateKey().publicKey.rawRepresentation.base64EncodedString(),
                                                 amount: 69,
                                                 comments: "Nice")
                    blockChain.addPendingTransaction(transaction)
                } label: {
                    Text("Send / Request SC")
                        .foregroundColor(.white)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .background(.blue)
                        .cornerRadius(30)
                        .padding()
                }
            }
        }
        .searchable(text: $searchText, prompt: Text("Search your friends or others"))
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct TransactionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransactionPageView()
//    }
//}
