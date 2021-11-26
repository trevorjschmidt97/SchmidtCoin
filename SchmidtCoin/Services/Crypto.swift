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
    
    static func genKeyPair() -> Curve25519.Signing.PrivateKey {
        return Curve25519.Signing.PrivateKey.init()
    }
    
    static func genKeyPairFromRawData(_ data: Data) -> Curve25519.Signing.PrivateKey? {
        return try? Curve25519.Signing.PrivateKey.init(rawRepresentation: data)
    }
    
    /**
     Returns nil if can't convert transaction to data, or the signature method throws an error
     Returns a signature(data) if successfully signs transaction data.
    */
    static func signTransaction(transaction: Transaction, privateKey: Curve25519.Signing.PrivateKey) -> Data? {
        if let transactionData = Transaction.transactionData(transaction: transaction) {
            return try? privateKey.signature(for: transactionData)
        }
        return nil
    }
    
    /**
     Returns false if no signature,  no fromAddress, or can't convert transaction to Data.
     Returns true iff the signature is valid for the address and data.
    */
    static func isValidSignature(transaction: Transaction) -> Bool {
        if let fromAddress = transaction.fromAddress,
           let signature = transaction.signature,
           let transactionData = Transaction.transactionData(transaction: transaction) {
            return fromAddress.isValidSignature(signature, for: transactionData)
        }
        return false
    }
    
//    static func signTransaction(transaction: Transaction, privateKey: P256.Signing.PrivateKey) -> P256.Signing.ECDSASignature? {
//        return try? privateKey.signature(for: transaction.transactionData)
//    }
//    
//    static func verifySignature(publicKey: P256.Signing.PublicKey, signature: P256.Signing.ECDSASignature, transaction: Transaction) -> Bool {
//        return publicKey.isValidSignature(signature, for: transaction.transactionData)
//    }
}
