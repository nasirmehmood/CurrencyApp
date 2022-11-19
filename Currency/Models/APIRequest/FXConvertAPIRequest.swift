//
//  FXConvertAPIRequest.swift
//  Currency
//
//  Created by Light on 18/11/2022.
//

import Foundation

struct FXConvertAPIRequest: Codable {
    var from: String
    var to: String
    var amount: Float
}
