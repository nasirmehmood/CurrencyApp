//
//  ConvertViewModel.swift
//  Currency
//
//  Created by Light on 19/11/2022.
//

import Foundation

class ConvertViewModel {
    
    enum ConversionStatus {
        case initiated
        case completed
        case failed
    }
    typealias ConversionResult = (ConversionStatus, Error?) -> Void
    
    var baseCurrency: String?
    var targetCurrency: String?
    var baseAmount: Float {
        didSet {
            if baseAmount == 0 {
                targetAmount = 0
            }
        }
    }
    var targetAmount: Float

    var currencyConversionUpdateBlock: ConversionResult?
    
    private var currencySymbolsList: [FXCurrencySymbol] = []
    var currenciesList: [String] {
        return currencySymbolsList.map({ $0.symbol }).sorted()
    }
    
    init() {
        baseCurrency = nil
        targetCurrency = nil
        baseAmount = 0.0
        targetAmount = 0.0
        loadCurrenciesList()
    }
    
    func toggleCurrency() {
        (baseCurrency, targetCurrency) = (targetCurrency, baseCurrency)
        performConversion()
    }
    
    func performConversion() {
        guard let baseCurrency = baseCurrency,
              let targetCurrency = targetCurrency,
              baseAmount > 0 else {return}

        currencyConversionUpdateBlock?(.initiated, nil)
        Task {
            do {
                let amount = try await convertAmount(baseCurrency: baseCurrency,
                                        targetCurrency: targetCurrency, baseAmount: baseAmount)
                self.targetAmount = amount
                currencyConversionUpdateBlock?(.completed, nil)
            }
            catch let error {
                currencyConversionUpdateBlock?(.failed, error)
            }
        }
    }

    private func loadCurrenciesList() {
        Task {
            do {
                let result = try await CurrencyDataStore.shared.getSymbols()
              currencySymbolsList = result.symbols
            } catch {
                print("loadCurrenciesList error: \(error)")
            }
        }
    }

    private func convertAmount(baseCurrency: String, targetCurrency: String, baseAmount: Float) async throws -> Float {
        let result = try await CurrencyDataStore.shared.convert(from: baseCurrency, to: targetCurrency, amount: baseAmount)
        return result.info.rate
    }
}
