//
//  TransactionView.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 11/29/21.
//

import SwiftUI

struct TransactionView: View {
    var transaction: Transaction
    
    var body: some View {
        
        VStack {
            VStack {
                if let fromAddress = transaction.fromAddress {
                    Text("@\(fromAddress)")
                } else {
                    Text("Block Reward")
                }
                Text("Paid \(transaction.amount.formatted()) SchmidtCoin to")
                    .fontWeight(.bold)
                Text("@\(transaction.toAddress)")
                
                Divider()
            }
        
        
            HStack {
                ProfileImageView(username: transaction.fromAddress ?? "B", size: 50)
                VStack(alignment:. leading) {
                    Text("\(transaction.timeStamp.longStringToDate().formatted())")
                    Divider()
                    Text("\(transaction.comments)")
                }
            }
        }
        .font(.caption)
        .padding(.horizontal, 5)
        .padding(.vertical, 10)
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(transaction: exampleTransaction)
    }
}
