//
//  Block.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 10/1/21.
//

import Foundation
import SwiftUI

struct Block: Identifiable {
    var index: Int
    var previousHash: String
    var timeStamp: String
    var transactions: [Transaction]
    var nonce: Int
    var hash: String = ""
    var id: Int {
        index
    }
    
    init(index: Int, transactions: [Transaction], previousHash: String = "") {
        self.index = index
        self.transactions = transactions
        self.previousHash = previousHash
        self.timeStamp = Date().toLongString()
        self.nonce = 0
        self.hash = Block.computeBlockHash(block: self)
    }
    
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
let exampleKeyPair = Crypto.genKeyPair()
let exampleBlock = Block(index: 1,
                         previousHash: "000b49eb89a620faedb1e6ea1e8aeeb8e0b3ba3978553be9adb8bd1d133389f5",
                         timeStamp: "2021-11-26 10:28:50.9430",
                         transactions: [
                            Transaction(fromPrivateKey: exampleKeyPair, toAddress: exampleKeyPair.publicKey, amount: 50, comments: "Test")
                         ],
                         nonce: 5626,
                         hash: "0007993194595c42a4634fb4fbeebd0a412311137321e34aa2a46df6dfe03b65")
