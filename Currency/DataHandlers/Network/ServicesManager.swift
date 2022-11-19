//
//  ServicesManager.swift
//  Currency
//
//  Created by Nasir Mehmood on 18/11/2022.
//

import Foundation

enum APIError: Error {
    case invalid(endpoint: APIEndpoint, params: Encodable?)
}

class ServicesManager {
    static let shared = ServicesManager()

    func performGetRequest(endpoint: APIEndpoint, params: Encodable? = nil, headers: [String: String] = [:]) async throws -> Data {
        var urlComponents = URLComponents(string: endpoint.path)
        if let params = params?.dictionary {
            urlComponents?.queryItems = params.map({ (key, value) in
                URLQueryItem(name: key, value: "\(value)")
            })
        }

        guard let url = urlComponents?.url else {throw APIError.invalid(endpoint: endpoint, params: params)}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        for header in headers {
            urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
        }

        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        if FeatureFlags.logsEnabled {
            if let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                print("==-result: \(result)")
            }
        }
        return data
    }
}
