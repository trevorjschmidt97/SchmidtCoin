import UIKit
//import CryptoKit
//
//func generatePrivateKey() -> Curve25519.Signing.PrivateKey {
//    return Curve25519.Signing.PrivateKey.init()
//}
//
//// Generate a key
//let keyPair1 = generatePrivateKey()
//// Change it to data
//let keyPair1PrivateData = keyPair1.rawRepresentation
//// Change it to a string
//let keyPair1PrivateString = keyPair1PrivateData.base64EncodedString()
//// Change it back to data
//let keyPairData = Data(base64Encoded: keyPair1PrivateString)
//
//if let keyPairData = keyPairData,
//   // Change it back to a key
//   let keyPair2 = try? Curve25519.Signing.PrivateKey.init(rawRepresentation: keyPairData) {
//    print(keyPair1.rawRepresentation.base64EncodedString())
//    print(keyPair2.rawRepresentation.base64EncodedString())
//
//    print(keyPair1.publicKey.rawRepresentation.base64EncodedString())
//    print(keyPair2.publicKey.rawRepresentation.base64EncodedString())
//}
//
//var seenNums: Set<Int> = []
//seenNums.ins

func test() {
    var array = [5, 2, 1]
    
    array.insert(0, at: 0)
    
    for index in stride(from: 0, to: array.count, by: 1) {
        print(array[index])
    }
    
    print(array.removeFirst())
    print(array.removeLast())
    
}

test()
