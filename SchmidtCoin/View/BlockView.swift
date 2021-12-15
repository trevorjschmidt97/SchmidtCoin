//
//  BlockView.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 11/26/21.
//

import SwiftUI

struct BlockView: View {
    var block: Block
    var body: some View {
        VStack(alignment: .leading) {
            Text("Block:   \(block.id)")
            
            HStack {
                Text("TimeStamp:")
                Spacer()
                Text("\(block.timeStamp)")
            }
            Divider()
            
            HStack {
                Text("Previous Hash:")
                Spacer()
                VStack {
                    Text("\(String(block.previousHash.prefix(22)))")
                    Text("\(String(block.previousHash.suffix(22)))")
                }
            }
            Divider()
            
            HStack {
                Text("Number of Transactions:")
                Spacer()
                Text("\(block.transactions.count)")
            }
            Divider()
            
            HStack {
                Text("Nonce:")
                Spacer()
                Text("\(block.nonce)")
            }
            Divider()
            
            HStack {
                Text("Hash:")
                Spacer()
                VStack {
                    Text("\(String(block.hash.prefix(22)))")
                    Text("\(String(block.hash.suffix(22)))")
                }
            }
        }
            .padding()
            .font(.caption)
    }
}

struct BlockChainView_Previews: PreviewProvider {
    static var previews: some View {
        BlockView(block: exampleBlock)
    }
}

