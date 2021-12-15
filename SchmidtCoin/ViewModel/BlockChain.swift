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
    @Published var isMining = false
    
    func onAppear() {
        FirebaseDatabaseService.shared.pullBlockChain { [weak self] blocks in
            DispatchQueue.main.async {
                self?.chain = blocks
            }
        }
        FirebaseDatabaseService.shared.pullPendingTransactions { [weak self] pendingTransactionsFromDb in
            DispatchQueue.main.async {
                self?.pendingTransactions = pendingTransactionsFromDb
            }
        }
    }
    
    var publishedTransactions: [Transaction] {
        var publishedTransactions: [Transaction] = []
        for block in chain {
            for transaction in block.transactions {
                publishedTransactions.append(transaction)
            }
        }
        
        return publishedTransactions.sorted { t1, t2 in
            t1.timeStamp.longStringToDate() > t2.timeStamp.longStringToDate()
        }
    }
    
    func confirmedTransactions(forPrivateKey privateKey: String) -> [Transaction] {
        var confirmedTransactions: [Transaction] = []
        for block in chain {
            for transaction in block.transactions {
                if transaction.toAddress == Crypto.getPublicKeyString(forPrivateKeyString: privateKey) ?? "" ||
                    transaction.fromAddress ?? "" == Crypto.getPublicKeyString(forPrivateKeyString: privateKey) ?? ""
                {
                    confirmedTransactions.append(transaction)
                }
            }
        }
        return confirmedTransactions.sorted { t1, t2 in
            t1.timeStamp.longStringToDate() > t2.timeStamp.longStringToDate()
        }
    }

    func pendingTransactions(forPrivateKey privateKey: String) -> [Transaction] {
        let pendingTransactionsList = Array(pendingTransactions.values) as [Transaction]
        return pendingTransactionsList.filter { transaction in
            if let fromAddress = transaction.fromAddress {
                return fromAddress == Crypto.getPublicKeyString(forPrivateKeyString: privateKey) ?? ""
            }
            return false
        }
    }
    
    func addPendingTransaction(_ transaction: Transaction) {
        // No from address
        guard let fromAddress = transaction.fromAddress else {
            print("no from address")
            return
        }
        
        // Not enough balance
        if transaction.amount > getBalanceOfWallet(address: fromAddress) {
            print("not enough balance")
            return
        }
        
        // Invalid signature
        if !Crypto.isValidSignature(transaction: transaction) {
            print("Invalidsignature")
            return
        }
        
//        pendingTransactions[transaction.id] = transaction
        FirebaseDatabaseService.shared.addPendingTransaction(transaction: transaction)
    }
    
    func minePendingTransactions(miningRewardPublicKey: String) {
        var index = 0
        var previousHash = ""
        var miningReward = 400.0
        let difficulty = 4
        
        if let latestBlock = latestBlock() {
            index = latestBlock.index + 1
            previousHash = latestBlock.hash
            // Change this for different miningReward / difficulty
            miningReward = miningReward - Double(latestBlock.index)
//            difficulty = difficulty + latestBlock.index
        }
        
        // Get pending transactions
        var pendingTransactionsList = Array(pendingTransactions.values) as [Transaction]
        var userBalances: [String:Double] = [:]
        for (i, transaction) in pendingTransactionsList.enumerated() {
            if !transaction.isValidSignature() {
                let badTransaction = pendingTransactionsList.remove(at: i)
                print("Transaction: \(badTransaction.id) invalid signature")
                continue
            }
            
            // Grab the balance if not already
            if let fromAddress = transaction.fromAddress,
               userBalances[fromAddress] == nil {
                userBalances[fromAddress] = getBalanceOfWallet(address: fromAddress)
            }
            if userBalances[transaction.toAddress] == nil {
                userBalances[transaction.toAddress] = getBalanceOfWallet(address: transaction.toAddress)
            }
            
            if let fromAddress = transaction.fromAddress {
                if transaction.amount > userBalances[fromAddress]! {
                    let badTransaction = pendingTransactionsList.remove(at: i)
                    print("Transaction: \(badTransaction.id) not enough balance")
                    continue
                }
            }
            
            // Now reset the balances
            if let fromAddress = transaction.fromAddress {
                userBalances[fromAddress] = userBalances[fromAddress]! - transaction.amount
                userBalances[transaction.toAddress] = userBalances[transaction.toAddress]! + transaction.amount
            }
            
        }
        
        // Add reward Transaction
        let rewardTransaction = Transaction(fromPrivateKey: nil, toAddress: miningRewardPublicKey, amount: miningReward, comments: "Mining Reward")
        pendingTransactionsList.append(rewardTransaction)
        var newBlock = Block(index: index, transactions: pendingTransactionsList, previousHash: previousHash)
        
        // Mine the newBlock
        isMining = true
        DispatchQueue.init(label: "mine").async {
            while (newBlock.hash.prefix(difficulty) != String(repeating: "0", count: difficulty) && self.isMining) {
                newBlock.nonce += 1
                newBlock.hash = Block.computeBlockHash(block: newBlock)
            }
            DispatchQueue.main.async {
                withAnimation {
                    if self.isMining {
                        FirebaseDatabaseService.shared.addBlockToChain(block: newBlock)
                        self.pendingTransactions.removeAll()
                        FirebaseDatabaseService.shared.deletePendingTransaction(transactions: newBlock.transactions)
                    }
                    
                    self.isMining = false
                }
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
    
    func latestBlock() -> Block? {
        chain.last
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
