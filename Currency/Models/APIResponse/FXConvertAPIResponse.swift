//
//  APIResponse.swift
//  Currency
//
//  Created by Light on 18/11/2022.
//

import Foundation

struct FXConvertAPIResponse: Codable {
    var date: String
    var info: FXConvertInfo
    var query: FXConvertQuery
    var result: Float
    var success: Bool
}

struct FXConvertInfo: Codable {
    var rate: Float
    var timestamp: Int
}

struct FXConvertQuery: Codable {
    var amount: Float
    var from: String
    var to: String
}

/**
 {
   "date": "2022-11-18",
   "info": {
     "rate": 60.972103,
     "timestamp": 1668780183
   },
   "query": {
     "amount": 1,
     "from": "AED",
     "to": "PKR"
   },
   "result": 60.972103,
   "success": true
 }
 */
