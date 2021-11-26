//
//  Date+String.swift
//  SchmidtCoin
//
//  Created by Trevor Schmidt on 10/1/21.
//

import Foundation

extension Date {
    func toLongString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        return formatter.string(from: self)
    }
}
