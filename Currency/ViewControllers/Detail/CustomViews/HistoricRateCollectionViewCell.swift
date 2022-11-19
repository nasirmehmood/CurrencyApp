//
//  HistoricRateCollectionViewCell.swift
//  Currency
//
//  Created by Light on 19/11/2022.
//

import UIKit

protocol HistoricRateInfo {
    var date: String {get}
    var symbol: String {get}
    var rate: Float {get}
}

class HistoricRateCollectionViewCell: UICollectionViewCell {

    static let defaultSize: CGSize = CGSize(width: 145, height: 55)

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func set(info: HistoricRateInfo) {
        dateLabel.text = info.date
        symbolLabel.text = info.symbol
        rateLabel.text = "\(info.rate)"
    }
}
