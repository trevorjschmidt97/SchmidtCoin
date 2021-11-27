//
//  BlockChain.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 10/1/21.
//

import Foundation
import SwiftUI

class BlockChain: ObservableObject {
    @Published var chain: [Block] = []
    @Published var pendingTransactions: [String:Transaction] = [:]
    
    func addPendingTransaction(_ transaction: Transaction) {
        // No from address
        guard let fromAddress = transaction.fromAddress else { return }
        
        // Not enough balance
        if transaction.amount > getBalanceOfWallet(address: fromAddress) {
            return
        }
        
        // Invalid signature
        if !Crypto.isValidSignature(transaction: transaction) {
            return
        }
        
        pendingTransactions[transaction.id] = transaction
    }
    
    func minePendingTransactions(miningRewardPublicKey: String) {
        var index = 0
        var previousHash = ""
        var miningReward = 400.0
        var difficulty = 3
        
        if !chain.isEmpty {
            index = latestBlock().index + 1
            previousHash = latestBlock().hash
            miningReward = miningReward - Double(latestBlock().index)
            difficulty = difficulty + latestBlock().index
        }
        
        let rewardTransaction = Transaction(fromPrivateKey: nil, toAddress: miningRewardPublicKey, amount: miningReward, comments: "Mining Reward")
        var pendingTransactionsList = Array(pendingTransactions.values)
        pendingTransactionsList.append(rewardTransaction)
        var newBlock = Block(index: index, transactions: pendingTransactionsList, previousHash: previousHash)
        
      
        newBlock.mine(difficulty: difficulty)
        
        
        print("newBlock mined!")
        
        withAnimation {
            self.chain.append(newBlock)
            for transaction in latestBlock().transactions {
                pendingTransactions.removeValue(forKey: transaction.id)
            }
        }
    }
    
    func getBalanceOfWallet(address: String) -> Double {
        var bal = 0.0
        
        for block in chain {
            for transaction in block.transactions {
                if let fromAddress = transaction.fromAddress {
                    if fromAddress == address {
                        bal -= transaction.amount
                    }
                }
                if transaction.toAddress == address {
                    bal += transaction.amount
                }
            }
        }
        
        return bal
    }
    
    func latestBlock() -> Block {
        chain.last!
    }
    
    func isChainValid() -> Bool {
        for (i, block) in chain.enumerated() {
            if i != 0 {
                if block.previousHash != chain[i-1].hash {
                    return false
                }
            }
            
            if block.hash != Block.computeBlockHash(block: block) {
                return false
            }
        }
        return true
    }
    
    func toString() -> String {
        var str = ""
        for block in chain {
            str += block.toString()
        }
        return str
    }
}
