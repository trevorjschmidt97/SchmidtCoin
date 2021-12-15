//
//  Block.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 10/1/21.
//

import Foundation

struct Block: Identifiable, Codable {
    var index: Int
    var previousHash: String
    var timeStamp: String
    var transactions: [Transaction]
    var nonce: Int
    var hash: String = ""
    
    // Computed Vars
    var id: Int {
        index
    }
    
    /**
     Initializing a new block in preparation to start mining.
    */
    init(index: Int, transactions: [Transaction], previousHash: String = "") {
        self.index = index
        self.transactions = transactions
        self.previousHash = previousHash
        self.timeStamp = Date().toLongString()
        self.nonce = 0
        self.hash = Block.computeBlockHash(block: self)
    }
    
    /**
     Basically the free init.
    */
    init(index: Int, previousHash: String, timeStamp: String, transactions: [Transaction], nonce: Int, hash: String) {
        self.index = index
        self.transactions = transactions
        self.previousHash = previousHash
        self.timeStamp = timeStamp
        self.transactions = transactions
        self.nonce = nonce
        self.hash = hash
    }
    
    static func computeBlockHash(block: Block) -> String {
        var transactionsString = ""
        for transaction in block.transactions {
            transactionsString += transaction.toString()
        }
        return Crypto.hash(fromString: String(block.index) + block.previousHash + block.timeStamp + transactionsString + String(block.nonce))
    }
    
    mutating func mine(difficulty: Int) {
        while (self.hash.prefix(difficulty) != String(repeating: "0", count: difficulty)) {
            self.nonce += 1
            self.hash = Block.computeBlockHash(block: self)
        }
    }
    
    func toString() -> String {
        var transactionsString = ""
        for transaction in transactions {
            transactionsString += transaction.toString()
        }
        var str = "Block \(index):\n"
        str += "\tPreviousHash: \(previousHash)\n"
        str += "\tTimeStamp: \(timeStamp)\n"
        str += "\tTransactions: \(transactionsString)\n"
        str += "\tNonce: \(nonce)\n"
        str += "\tHash: \(hash)\n"
        return str
    }
}

let exampleBlock = Block(index: 1,
                         previousHash: "000082ca0e14e38703fb82ad4bf6f52953383c445175df2d9d03474fc4bb98a8",
                         timeStamp: "2021-11-27 16:17:24.2980",
                         transactions: [
                            Transaction(id: "B425B54F-AB00-474F-83A6-B709FB548882",
                                        timeStamp: "2021-11-27 16:17:24.2980",
                                        amount: 400,
                                        comments: "Mining Reward",
                                        fromAddress: nil,
                                        toAddress: "5HRcLBVpBP5aYTKl5U2XxUS5n9VAiefHGhjkjk67kBs=",
                                        signature: nil)
                         ],
                         nonce: 5626,
                         hash: "0007993194595c42a4634fb4fbeebd0a412311137321e34aa2a46df6dfe03b65")
