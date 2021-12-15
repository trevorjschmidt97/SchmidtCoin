//
//  SignUpPageView.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 11/27/21.
//

import SwiftUI
import CryptoKit
import MobileCoreServices

struct SignUpPageView: View {
    @State private var privateKey: String? = UserDefaults.standard.string(forKey: "privateKey")
    @State private var publicKey: String? = UserDefaults.standard.string(forKey: "publicKey")
    
    var body: some View {
        Form {
            Section("KeyPair") {
                HStack {
                    Text("Public Key: ")
                    Spacer()
                    VStack {
                        Text("\(String(publicKey?.prefix(22) ?? ""))")
                        Text("\(String(publicKey?.suffix(22) ?? ""))")
                    }
                    .font(.caption)
                }
                HStack {
                    Text("Private Key:")
                    Spacer()
                    VStack {
                        Text("\(String(privateKey?.prefix(22) ?? ""))")
                        Text("\(String(privateKey?.suffix(22) ?? ""))")
                    }
                        .font(.caption)
                    if let privateKey = privateKey {
                        Button {
                            UIPasteboard.general.setValue(privateKey, forPasteboardType: kUTTypePlainText as String)
                        } label: {
                            Image(systemName: "doc.on.clipboard")
                        }
                    }
                }
                Button {
                    (privateKey, publicKey) = Crypto.generateKeyPair()
                } label: {
                    HStack {
                        Spacer()
                        Text("\(privateKey != nil ? "Re-" : "")Generate Keys")
                        Spacer()
                    }
                }
            }
            
            Button {
                UserDefaults.standard.set(privateKey, forKey: "privateKey")
                UserDefaults.standard.set(publicKey, forKey: "publicKey")
                AppViewModel.shared.privateKey = privateKey
            } label: {
                HStack {
                    Spacer()
                    Text("Sign In")
                    Spacer()
                }
            }

        }
            .navigationTitle("Sign Up")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        SignUpPageView()
        }
    }
}
