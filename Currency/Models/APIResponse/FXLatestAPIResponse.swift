//
//  FXLatestAPIResponse.swift
//  Currency
//
//  Created by Light on 18/11/2022.
//

import Foundation

struct FXLatestAPIResponse: Codable {
    var base: String
    var date: String
    var rates: [FXLatestRate]
    var success: Bool
    var timestamp: Int
    
    enum CodingKeys: String, CodingKey {
        case base, date, rates, success, timestamp
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        base = try values.decode(String.self, forKey: .base)
        date = try values.decode(String.self, forKey: .date)
        success = try values.decode(Bool.self, forKey: .success)
        timestamp = try values.decode(Int.self, forKey: .timestamp)

        var allRates = [FXLatestRate]()
        let rateValues = try values.decode([String: Float].self, forKey: .rates)
        for rateValue in rateValues {
            let symbol = rateValue.key
            let rate = rateValue.value
            allRates.append(FXLatestRate(symbol: symbol, rate: rate))
        }
        rates = allRates
    }
}

struct FXLatestRate: Codable {
    var symbol: String
    var rate: Float
}

/**
 {
   "base": "AED",
   "date": "2022-11-18",
   "rates": {
     "AUD": 0.406455,
     "CAD": 0.363724,
     "EGP": 6.674392,
     "EUR": 0.262708,
     "GBP": 0.228676,
     "INR": 22.238485,
     "JPY": 38.125253,
     "PKR": 60.970554,
     "USD": 0.272249
   },
   "success": true,
   "timestamp": 1668779763
 }
 */
