//
//  Transaction.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 10/1/21.
//

import Foundation

struct Transaction: Identifiable, Codable {
    var id = UUID().uuidString
    var timeStamp: String
    var amount: Double
    var comments: String
    var fromAddress: String?
    var toAddress: String
    var signature: String?
    
    static func transactionData(transaction: Transaction) -> Data? {
        var transactionString = transaction.id
        transactionString += transaction.timeStamp
        transactionString += String(transaction.amount)
        transactionString += transaction.comments
        transactionString += transaction.fromAddress ?? ""
        transactionString += transaction.toAddress
        return transactionString.data(using: .utf8)
    }

    /**
     Creation of a transaction. Everything necessary except for the fromAddress (if transaction reward).
        If a reward, then there will be no signature created either.
    */
    init(fromPrivateKey: String?,
         toAddress: String,
         amount: Double,
         comments: String) {
        self.timeStamp = Date().toLongString()
        self.toAddress = toAddress
        self.amount = amount
        self.comments = comments
        
        if let fromPrivateKey = fromPrivateKey {
            self.fromAddress = Crypto.getPublicKeyString(forPrivateKeyString: fromPrivateKey)
            self.signature = Crypto.signTransaction(transaction: self, privateKeyString: fromPrivateKey)
        }
    }
    
    /**
     Basically the free init.
    */
    init(id: String,
         timeStamp: String,
         amount: Double,
         comments: String,
         fromAddress: String?,
         toAddress: String,
         signature: String?) {
        self.id = id
        self.timeStamp = timeStamp
        self.amount = amount
        self.comments = comments
        self.fromAddress = fromAddress
        self.toAddress = toAddress
        self.signature = signature
    }
    
    func isValidSignature() -> Bool {
        return Crypto.isValidSignature(transaction: self)
    }
    
    func toString() -> String {
        var str = "id: \(id)\n"
        str += "\ttimeStamp: \(timeStamp)\n"
        str += "\tAmount: \(String(amount))\n"
        str += "\tComments: \(comments)\n"
        str += "\tfromAddress: \(fromAddress ?? "")\n"
        str += "\ttoAddress: \(toAddress)\n"
        str += "\tsignature: \(signature ?? "")\n"
        return str
    }
}

var exampleTransaction = Transaction(id: "53AD8111-A19A-4FF2-8727-64E3C55A779B",
                                     timeStamp: "2021-11-30 10:57:10.1430",
                                     amount: 69.0,
                                     comments: "Nice",
                                     fromAddress: "ajKg2KSttCiT+PjxB3/bUAbK/6OX7e1u897nT+NhS/8=",
                                     toAddress: "OnkOkGZKJfPxlPeuvsux7AxtE/CxVGNRvRZXceFoi0c=",
                                     signature: "GfgeV7Q5d6tBGtaGFMj5rP9+YZGLQ5uWjcehxn17Zd99SzOHSfYw+xF4cnOfG0vnoBnZyOEa39qBVblFjVRSDg==")
