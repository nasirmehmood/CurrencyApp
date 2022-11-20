//
//  HistoricViewModel.swift
//  Currency
//
//  Created by Light on 19/11/2022.
//

import Foundation

class HistoricViewModel {
    
    enum Sections: Int, CaseIterable {
        case chart = 0
        case historyList
    }
    
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
    
    func numberOfItems(section: Int) -> Int {
        let section = Sections(rawValue: section)!
        switch section {
        case .chart:
            return 1
        case .historyList:
            return historicRates.count
        }
    }
    
    func itemInfo(for indexPath: IndexPath) -> HistoricRateInfo {
        return historicRates[indexPath.item]
    }
}

extension HistoricViewModel {
    var chartValues: [Float] {
        historicRates.map({$0.rate})
    }
    
    var chartLabels: [String] {
        historicRates.map({$0.date.defaultFormatDate.dateMonthFormatted })        
    }
}

extension FXTimeSeriesRates: HistoricRateInfo { }
