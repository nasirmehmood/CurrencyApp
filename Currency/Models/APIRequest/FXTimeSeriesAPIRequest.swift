//
//  FXTimeSeriesAPIRequest.swift
//  Currency
//
//  Created by Light on 18/11/2022.
//

import Foundation

struct FXTimeSeriesAPIRequest: Codable {
    var base: String
    var symbols: [String]
    var startDate: String
    var endDate: String
    
    enum CodingKeys: String, CodingKey {
        case base, symbols
        case startDate = "start_date"
        case endDate = "end_date"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(base, forKey: .base)
        try container.encode(symbols.joined(separator: ","), forKey: .symbols)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
    }
}
