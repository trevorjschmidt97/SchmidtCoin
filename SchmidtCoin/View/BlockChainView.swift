//
//  BlockChainView.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 11/26/21.
//

import SwiftUI

struct BlockChainView: View {
    var chain: [Block]
    var body: some View {
        ForEach(chain) { block in
            Text(block.toString())
                .font(.caption)
        }
    }
}

struct BlockChainView_Previews: PreviewProvider {
    static var previews: some View {
        BlockChainView(chain: [exampleBlock])
    }
}

