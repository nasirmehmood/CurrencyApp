//
//  HistoricViewModel.swift
//  Currency
//
//  Created by Light on 19/11/2022.
//

import Foundation

class HistoricViewModel {
    
    var baseCurrency: String
    var targetCurrency: String
    
    var historicRates: [FXTimeSeriesRates] = []
    var fetchStatusBlock: FetchStatusBlock?

    init(baseCurrency: String, targetCurrency: String) {
        self.baseCurrency = baseCurrency
        self.targetCurrency = targetCurrency
    }
    
    func loadCurrencyHistory() {
        let pastDates = Date.pastDates(for: 3)
        let startDate = (pastDates.last?.defaultFormatted)!
        let endDate = (pastDates.first?.defaultFormatted)!
        fetchStatusBlock?(.initiated, nil)
        Task {
            do {
                let result = try await CurrencyDataStore.shared.getTimeSeries(base: baseCurrency,
                                               symbols: [targetCurrency], startDate: startDate, endDate: endDate)
                historicRates = result.rates
                fetchStatusBlock?(.completed, nil)
            }
            catch {
                if FeatureFlags.logsEnabled {
                    print("loadCurrencyHistory error: \(error)")
                }
                fetchStatusBlock?(.failed, error)
            }
        }
    }
    
    var numberOfItems: Int {
        return historicRates.count
    }
    
    func itemInfo(for index: Int) -> HistoricRateInfo {
        return historicRates[index]
    }
}

extension FXTimeSeriesRates: HistoricRateInfo { }
