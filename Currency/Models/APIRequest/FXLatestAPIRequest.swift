//
//  FXLatestAPIRequest.swift
//  Currency
//
//  Created by Light on 18/11/2022.
//

import Foundation

struct FXLatestAPIRequest: Codable {
    var base: String
    var symbols: [String]
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(base, forKey: .base)
        try container.encode(symbols.joined(separator: ","), forKey: .symbols)
    }
}
