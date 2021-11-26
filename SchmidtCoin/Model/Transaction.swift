//
//  Transaction.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 10/1/21.
//

import Foundation
import CryptoKit

struct Transaction: Identifiable {
    var id = UUID().uuidString
    var timeStamp: String
    var amount: Double
    var comments: String
    var fromAddress: Curve25519.Signing.PublicKey?
    var toAddress: Curve25519.Signing.PublicKey
    var signature: Data?
    
    static func transactionData(transaction: Transaction) -> Data? {
        var transactionString = transaction.id
        transactionString += transaction.timeStamp
        transactionString += String(transaction.amount)
        transactionString += transaction.comments
        transactionString += transaction.fromAddress?.rawRepresentation.base64EncodedString() ?? ""
        transactionString += transaction.toAddress.rawRepresentation.base64EncodedString()
        return transactionString.data(using: .utf8)
    }

    /**
     Creation of a transaction. Everything necessary except for the fromAddress (if transaction reward).
        If a reward, then there will be no signature created either.
    */
    init(fromPrivateKey: Curve25519.Signing.PrivateKey?, toAddress: Curve25519.Signing.PublicKey, amount: Double, comments: String) {
        self.timeStamp = Date().toLongString()
        self.toAddress = toAddress
        self.amount = amount
        self.comments = comments
        // Signing of the Transaction
        self.fromAddress = fromPrivateKey?.publicKey
        if let privateKey = fromPrivateKey {
            self.signature = Crypto.signTransaction(transaction: self, privateKey: privateKey)
        }
    }
    
    func toString() -> String {
        var str = "\n\t\tid: \(id)\n"
        str += "\t\t\ttimeStamp: \(timeStamp)\n"
        str += "\t\t\tAmount: \(String(amount))\n"
        str += "\t\t\tComments: \(comments)\n"
        str += "\t\t\tfromAddress: \(fromAddress?.rawRepresentation.base64EncodedString() ?? "")\n"
        str += "\t\t\ttoAddress: \(toAddress.rawRepresentation.base64EncodedString())\n"
        str += "\t\t\tsignature: \(signature?.base64EncodedString() ?? "")"
        return str
    }
}
