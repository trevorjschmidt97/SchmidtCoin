//
//  FirebaseDatabaseService.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 11/30/21.
//

import Foundation
import FirebaseDatabase
import CodableFirebase

struct FirebaseDatabaseService {
    static let shared = FirebaseDatabaseService()
    private init() { }
    
    private let rootRef = Database.database().reference()
    
    func addBlockToChain(block: Block) {
        let data = try! FirebaseEncoder().encode(block)
        rootRef.child("blockChain").child(String(block.id)).setValue(data)
    }
    
    func pullBlockChain(completion: @escaping ([Block]) -> Void) {
        rootRef.child("blockChain").observe(.value) { snapshot in
            guard let value = snapshot.value else { return }
            
            do {
                let model = try FirebaseDecoder().decode([Block].self, from: value)
                completion(model.sorted { b1, b2 in
                    b1.timeStamp.longStringToDate() < b2.timeStamp.longStringToDate()
                })
            } catch let error {
                print("Error in file \(#filePath), line \(#line)")
                print(error)
            }
            
        }
    }
    
    func addPendingTransaction(transaction: Transaction) {
        let data = try! FirebaseEncoder().encode(transaction)
        rootRef.child("pendingTransactions").child(transaction.id).setValue(data)
    }
    
    func deletePendingTransaction(transactions: [Transaction]) {
        for transaction in transactions {
            rootRef.child("pendingTransactions").child(transaction.id).setValue(nil)
        }
    }
    
    func pullPendingTransactions(completion: @escaping([String:Transaction]) -> Void) {
        rootRef.child("pendingTransactions").observe(.value) { snapshot in
            guard let value = snapshot.value else { return }
            do {
                let model = try FirebaseDecoder().decode([String:Transaction].self, from: value)
                completion(model)
            } catch let error {
                print("Error in file \(#filePath), line \(#line)")
                print(error)
            }
        }
    }
}
