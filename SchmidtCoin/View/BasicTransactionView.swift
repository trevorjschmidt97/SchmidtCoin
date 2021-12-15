//
//  BasicTransactionView.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 12/12/21.
//

import SwiftUI

struct BasicTransactionView: View {
    
    var transaction: Transaction
    
    @State private var heartPressed = false
    @State private var bubblePressed = false
    
    var body: some View {
        HStack {
            VStack {
                ProfileImageView(username: "test", size: 50)
                    .padding(.vertical)
                HStack {
                    Button {
                        heartPressed.toggle()
                    } label: {
                        Image(systemName: heartPressed ? "heart.fill" : "heart")
                    }
                    .foregroundColor(.blue)
                    
                    Button {
                        bubblePressed.toggle()
                    } label: {
                        Image(systemName: bubblePressed ? "bubble.left.fill" : "bubble.left")
                    }
                    .foregroundColor(.blue)
                }
                .padding(.leading, -13)
                Spacer()
            }
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("**\(String(transaction.fromAddress?.prefix(10) ?? "Block Reward"))** paid **\(String(transaction.toAddress.prefix(10)))**")
                            .fixedSize(horizontal: false, vertical: true)
                        Text("1h")
                            .font(.caption)
                            .padding(.top, -5)
                    }
                    .padding(.bottom, 0.1)
                    Spacer()
                    Text("\(transaction.amount.formatted()) SC")
                }
                Text("\(transaction.comments) lskdjflaksdjf lasdkjflkasdjf jksdlfjkdfjk dkljfslkdjfk eo kdlfjlakdfn oiejfn")
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
//        VStack {
//            HStack(alignment: .top) {
//                VStack(alignment: .leading) {
//                    Text("**\("test")** paid **test2**")
//                        .padding(.bottom, 0.1)
//                    Text("1h")
//                        .font(.caption)
//                }
//                Spacer()
//                Text("\(transaction.amount.formatted()) SC")
//            }
//
//            HStack {
//                VStack(alignment: .leading) {
//                    Text("Hello")
//                        .padding(.vertical, 3)
//                    HStack {
//                        Image(systemName: "heart")
//                        Image(systemName: "bubble.left")
//                    }
//                    .padding(.vertical, 3)
//
//                }
//                Spacer()
//            }
//        }
    }
}

struct BasicTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            BasicTransactionView(transaction: exampleTransaction)
        }
    }
}
