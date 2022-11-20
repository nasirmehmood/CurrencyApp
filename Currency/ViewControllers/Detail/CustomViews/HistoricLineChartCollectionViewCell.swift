//
//  HistoricLineChartCollectionViewCell.swift
//  Currency
//
//  Created by Light on 20/11/2022.
//

import UIKit
import Charts

class HistoricLineChartCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lineChartView: LineChartView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.granularity = 1
        lineChartView.xAxis.granularityEnabled = true
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.avoidFirstLastClippingEnabled = true
    }

    func updateChart(values: [Float], labels: [String]) {
        var lineChartDataEntries = [ChartDataEntry]()
        for i in 0..<values.count {
            let value = ChartDataEntry(x: Double(10 * i), y: Double(values[i]))
            lineChartDataEntries.append(value)
        }

        let lineChartDataSet = LineChartDataSet(entries: lineChartDataEntries)
        lineChartDataSet.colors = [UIColor(named: "AccentColor")!]

        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        lineChartView.chartDescription.text = "Currency History"
        lineChartView.xAxis.valueFormatter = XAxisValueFormatter(values: labels)
        lineChartView.xAxis.setLabelCount(labels.count, force: true)
    }
}

class XAxisValueFormatter: IndexAxisValueFormatter {
    override func stringForValue(_ value: Double,
                        axis: AxisBase?) -> String {
        let index = Int(value)/10
        if index < values.count {
            return values[index]
        }
        
        return ""
    }
}
