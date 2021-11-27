//
//  Transaction.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 10/1/21.
//

import Foundation

struct Transaction: Identifiable {
    var id = UUID().uuidString
    var timeStamp: String
    var amount: Double
    var comments: String
    var fromAddress: String?// Curve25519.Signing.PublicKey?
    var toAddress: String//Curve25519.Signing.PublicKey
    var signature: String?
    
    static func transactionData(transaction: Transaction) -> Data? {
        var transactionString = transaction.id
        transactionString += transaction.timeStamp
        transactionString += String(transaction.amount)
        transactionString += transaction.comments
        transactionString += transaction.fromAddress ?? ""//.rawRepresentation.base64EncodedString() ?? ""
        transactionString += transaction.toAddress//.rawRepresentation.base64EncodedString()
        return transactionString.data(using: .utf8)
    }

    /**
     Creation of a transaction. Everything necessary except for the fromAddress (if transaction reward).
        If a reward, then there will be no signature created either.
    */
    init(fromPrivateKey: String?,//Curve25519.Signing.PrivateKey?,
         toAddress: String,//Curve25519.Signing.PublicKey,
         amount: Double,
         comments: String) {
        self.timeStamp = Date().toLongString()
        self.toAddress = toAddress
        self.amount = amount
        self.comments = comments
        // Signing of the Transaction
        
        // If there is a fromPrivateKey string
        
        if let fromPrivateKey = fromPrivateKey {
            self.fromAddress = Crypto.getPublicKeyString(forPrivateKeyString: fromPrivateKey)
            self.signature = Crypto.signTransaction(transaction: self, privateKeyString: fromPrivateKey)
        }
    }
    
    func toString() -> String {
        var str = "\n\t\tid: \(id)\n"
        str += "\t\t\ttimeStamp: \(timeStamp)\n"
        str += "\t\t\tAmount: \(String(amount))\n"
        str += "\t\t\tComments: \(comments)\n"
        str += "\t\t\tfromAddress: \(fromAddress ?? "")\n"//.rawRepresentation.base64EncodedString() ?? "")\n"
        str += "\t\t\ttoAddress: \(toAddress)\n"//.rawRepresentation.base64EncodedString())\n"
        str += "\t\t\tsignature: \(signature ?? "")"//".base64EncodedString() ?? "")"
        return str
    }
}
