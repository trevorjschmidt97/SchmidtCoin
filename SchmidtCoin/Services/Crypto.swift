//
//  Crypto.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 10/1/21.
//

import Foundation
import CryptoKit

struct Crypto {
    static func hash(fromString input: String) -> String {
        let data = Data(input.utf8) // Data
        let hash = SHA256.hash(data: data) // Hash the data
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
    
    static func generatePrivateKey() -> Curve25519.Signing.PrivateKey {
        return Curve25519.Signing.PrivateKey.init()
    }
    
    static func generatePrivateKey(fromString: String) -> Curve25519.Signing.PrivateKey? {
        if let data = fromString.data(using: .utf8) {
            return try? Curve25519.Signing.PrivateKey.init(rawRepresentation: data)
        }
        return nil
    }
    
    static func generatePublicKey(fromString: String) -> Curve25519.Signing.PublicKey? {
        if let data = fromString.data(using: .utf8) {
            return try? Curve25519.Signing.PublicKey.init(rawRepresentation: data)
        }
        return nil
    }
    
    static func getPublicKeyString(forPrivateKeyString skString: String) -> String? {
        if let sk = generatePrivateKey(fromString: skString) {
            return sk.publicKey.rawRepresentation.base64EncodedString()
        }
        return nil
    }
    
    /**
     Returns nil if can't convert transaction to data, or the signature method throws an error
     Returns a signature(data) if successfully signs transaction data.
    */
    static func signTransaction(transaction: Transaction, privateKeyString: String) -> String? {
        if let privateKey = generatePrivateKey(fromString: privateKeyString),
           let transactionData = Transaction.transactionData(transaction: transaction),
           let signatureData = try? privateKey.signature(for: transactionData) {
            return signatureData.base64EncodedString()
        }
        return nil
    }
    
    /**
     Returns false if no signature,  no fromAddress, or can't convert transaction to Data.
     Returns true iff the signature is valid for the address and data.
    */
    static func isValidSignature(transaction: Transaction) -> Bool {
        if let fromAddress = transaction.fromAddress,
           let fromPublicKey = Crypto.generatePublicKey(fromString: fromAddress),
           let signature = transaction.signature,
           let signatureData = signature.data(using: .utf8),
           let transactionData = Transaction.transactionData(transaction: transaction) {
            return fromPublicKey.isValidSignature(signatureData, for: transactionData)
        }
        return false
    }
}
