//
//  SymbolsAPIResponse.swift
//  Currency
//
//  Created by Light on 18/11/2022.
//

import Foundation

struct FXSymbolsAPIResponse: Codable {
    var success: Bool
    var symbols: [FXCurrencySymbol]
    
    enum CodingKeys: String, CodingKey {
        case success
        case symbols
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decode(Bool.self, forKey: .success)
        
        var allSymbols = [FXCurrencySymbol]()
        do {
            let symbolValues = try values.decode([String:String].self, forKey: .symbols)
            for symbolValue in symbolValues {
                let symbol = symbolValue.key
                let countryName = symbolValue.value
                allSymbols.append(FXCurrencySymbol(symbol: symbol, countryName: countryName))
            }
            symbols = allSymbols
        } catch {
            let allSymbols = try values.decode([FXCurrencySymbol].self, forKey: .symbols)
            symbols = allSymbols
        }
    }
}

struct FXCurrencySymbol: Codable {
    var symbol: String
    var countryName: String
}

/**
{
    "success": true,
    "symbols": {
        "AED": "United Arab Emirates Dirham",
        "AFN": "Afghan Afghani",
        "ALL": "Albanian Lek"
    }
}
 */
