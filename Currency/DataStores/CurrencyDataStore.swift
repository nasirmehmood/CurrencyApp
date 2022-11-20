//
//  CurrencyDataStore.swift
//  Currency
//
//  Created by Light on 18/11/2022.
//

import Foundation
import UserDefault

class CurrencyDataStore {
    enum HeaderKeys {
        static let apiKey = "apiKey"
    }
    static let apiKey = "ZsRh8F7AocVa1y9yK9r7Po39lewiY5pE"// "2JUJtlfYfUfcgH6o2LwY3mzUUOxkTkQc"
    static let shared = CurrencyDataStore()

    @UserDefaultCodable(key: "symbols") private var symbolsResponse: FXSymbolsAPIResponse?
    
    func getSymbols() async throws -> FXSymbolsAPIResponse {
        if let symbolsResponse = symbolsResponse,
           symbolsResponse.success == true,
           !symbolsResponse.symbols.isEmpty {
            return symbolsResponse
        }

        let data = try await ServicesManager.shared.performGetRequest(endpoint: APIEndpoint.symbols,
                                                                      headers: [HeaderKeys.apiKey: Self.apiKey])
        let response = try JSONDecoder().decode(FXSymbolsAPIResponse.self, from: data)
        symbolsResponse = response
        UserDefaults.standard.synchronize()
        return response
    }

    func convert(from: String, to: String, amount: Float) async throws -> FXConvertAPIResponse {
        if FeatureFlags.debugDataEnabled {
            let response = FXConvertAPIResponse(date: "2022-11-20",
                                                info: FXConvertInfo(rate: 23.958447, timestamp: 1668944403),
                                                query: FXConvertQuery(amount: 1, from: "AED", to: "AFN"),
                                                result: 23.958447, success: true)
            return response
        }
        
        let params = FXConvertAPIRequest(from: from, to: to, amount: amount)
        let data = try await ServicesManager.shared.performGetRequest(endpoint: APIEndpoint.convert,
                                                                      params: params,
                                                                      headers: [HeaderKeys.apiKey: Self.apiKey])
        let response = try JSONDecoder().decode(FXConvertAPIResponse.self, from: data)
        return response
    }

    func getLatest(base: String, symbols: [String]) async throws -> FXLatestAPIResponse {
        let params = FXLatestAPIRequest(base: base, symbols: symbols)
        let data = try await ServicesManager.shared.performGetRequest(endpoint: APIEndpoint.latest,
                                                                      params: params,
                                                                      headers: [HeaderKeys.apiKey: Self.apiKey])
        let response = try JSONDecoder().decode(FXLatestAPIResponse.self, from: data)
        return response
    }

    func getTimeSeries(base: String, symbols: [String], startDate: String, endDate: String) async throws -> FXTimeSeriesAPIResponse {
        if FeatureFlags.debugDataEnabled {
            let response = FXTimeSeriesAPIResponse(base: "AED", endDate: "2022-11-20",
                                                   startDate: "2022-11-18", timeseries: true,
                                                   success: true, rates: [
                                                    FXTimeSeriesRates(date: "2022-11-18", symbol: "AFN", rate: 23.958447),
                                                    FXTimeSeriesRates(date: "2022-11-19", symbol: "AFN", rate: 23.958447),
                                                    FXTimeSeriesRates(date: "2022-11-20", symbol: "AFN", rate: 23.958447)
                                                   ])
            return response
        }
        
        let params = FXTimeSeriesAPIRequest(base: base, symbols: symbols, startDate: startDate, endDate: endDate)
        let data = try await ServicesManager.shared.performGetRequest(endpoint: APIEndpoint.timeSeries,
                                                                      params: params,
                                                                      headers: [HeaderKeys.apiKey: Self.apiKey])
        let response = try JSONDecoder().decode(FXTimeSeriesAPIResponse.self, from: data)
        return response
    }
}

//
//
///************************************************************************************************************************/
//
//func date() {
//
//    var semaphore = DispatchSemaphore (value: 0)
//
//    let url = "https://api.apilayer.com/fixer/2022-11-17?symbols=PKR%2CUSD%2CGBP%2CEUR%2CJPY%2CEGP%2CINR%2CAUD%2CCAD%2CCNH&base=AED"
//    var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
//    request.httpMethod = "GET"
//    request.addValue("2JUJtlfYfUfcgH6o2LwY3mzUUOxkTkQc", forHTTPHeaderField: "apikey")
//
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//      guard let data = data else {
//        print(String(describing: error))
//        return
//      }
//      print(String(data: data, encoding: .utf8)!)
//      semaphore.signal()
//    }
//
//    task.resume()
//    semaphore.wait()
//
//    /**
//     {
//       "base": "AED",
//       "date": "2022-11-17",
//       "historical": true,
//       "rates": {
//         "AUD": 0.407017,
//         "CAD": 0.362717,
//         "EGP": 6.674823,
//         "EUR": 0.262755,
//         "GBP": 0.229566,
//         "INR": 22.195181,
//         "JPY": 38.228866,
//         "PKR": 60.561816,
//         "USD": 0.272249
//       },
//       "success": true,
//       "timestamp": 1668729599
//     }
//     */
//}
//
//
//func fluctuation() {
//    var semaphore = DispatchSemaphore (value: 0)
//
//    let url = "https://api.apilayer.com/fixer/fluctuation?start_date=2022-11-15&end_date=2022-11-18"
//    var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
//    request.httpMethod = "GET"
//    request.addValue("2JUJtlfYfUfcgH6o2LwY3mzUUOxkTkQc", forHTTPHeaderField: "apikey")
//
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//      guard let data = data else {
//        print(String(describing: error))
//        return
//      }
//      print(String(data: data, encoding: .utf8)!)
//      semaphore.signal()
//    }
//
//    task.resume()
//    semaphore.wait()
//
//    /**
//     {
//       "base": "AED",
//       "end_date": "2022-11-18",
//       "fluctuation": true,
//       "rates": {
//         "PKR": {
//           "change": 0.551,
//           "change_pct": 0.9119,
//           "end_rate": 60.972102,
//           "start_rate": 60.421128
//         }
//       },
//       "start_date": "2022-11-15",
//       "success": true
//     }
//
//     */
//
//}
