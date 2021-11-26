//
//  AppViewModel.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 11/23/21.
//

import Foundation

class AppViewModel: ObservableObject {
    static let shared = AppViewModel()
    private init() { }
    
    let keypair = Crypto.genKeyPair()
}
