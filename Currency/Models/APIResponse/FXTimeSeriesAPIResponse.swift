//
//  FXTimeSeriesAPIResponse.swift
//  Currency
//
//  Created by Light on 18/11/2022.
//

import Foundation

struct FXTimeSeriesAPIResponse: Codable {
    var base: String
    var endDate: String
    var startDate: String
    var timeseries: Bool
    var success: Bool
    var rates: [FXTimeSeriesRates]
    
    enum CodingKeys: String, CodingKey {
        case base, timeseries, success, rates
        case startDate = "start_date"
        case endDate = "end_date"
    }
    
    init(base: String, endDate: String, startDate: String,
         timeseries: Bool, success: Bool, rates: [FXTimeSeriesRates]) {
        self.base = base
        self.endDate = endDate
        self.startDate = startDate
        self.timeseries = timeseries
        self.success = success
        self.rates = rates
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        base = try values.decode(String.self, forKey: .base)
        timeseries = try values.decode(Bool.self, forKey: .timeseries)
        success = try values.decode(Bool.self, forKey: .success)
        startDate = try values.decode(String.self, forKey: .startDate)
        endDate = try values.decode(String.self, forKey: .endDate)
        
        var timeSeriesRates = [FXTimeSeriesRates]()
        let rateValues = try values.decode([String: [String: Float]].self, forKey: .rates)
        for rateValue in rateValues {
            let date = rateValue.key
            let rateInfo = rateValue.value
            for rate in rateInfo {
                let timeSeriesRate = FXTimeSeriesRates(date: date, symbol: rate.key, rate: rate.value)
                timeSeriesRates.append(timeSeriesRate)
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        rates = timeSeriesRates.sorted { rate1, rate2 in
            return dateFormatter.date(from: rate1.date)! < dateFormatter.date(from: rate2.date)!
        }
    }
}

struct FXTimeSeriesRates: Codable {
    var date: String
    var symbol: String
    var rate: Float
}

/**
 {
   "base": "AED",
   "end_date": "2022-11-18",
   "rates": {
     "2022-11-15": {
       "PKR": 60.421128
     },
     "2022-11-16": {
       "PKR": 60.561909
     },
     "2022-11-17": {
       "PKR": 60.561816
     },
     "2022-11-18": {
       "PKR": 60.972099
     }
   },
   "start_date": "2022-11-15",
   "success": true,
   "timeseries": true
 }
 */

/**
 {
     error =     {
         code = 504;
         info = "You have entered an invalid Time-Frame. [Required format: ...&start_date=YYYY-MM-DD&end_date=YYYY-MM-DD]";
         type = "invalid_time_frame";
     };
     success = 0;
 }
 */
