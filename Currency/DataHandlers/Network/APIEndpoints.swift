//
//  APIEndpoints.swift
//  Currency
//
//  Created by Light on 18/11/2022.
//

import Foundation

enum APIEndpoint {
    case symbols
    case latest
    case convert
    case timeSeries

    var path: String {
        let base = "https://api.apilayer.com/fixer/"
        switch self {
        case .symbols:
            return base + "symbols"
        case .latest:
            return base + "latest"
        case .convert:
            return base + "convert"
        case .timeSeries:
            return base + "timeseries"
        }
    }

    var url: URL {
        return URL(string: path)!
    }
}
