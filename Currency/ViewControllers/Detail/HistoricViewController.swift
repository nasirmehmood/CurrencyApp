//
//  HistoricViewController.swift
//  Currency
//
//  Created by Light on 19/11/2022.
//

import UIKit

class HistoricViewController: UIViewController {
    static let identifier = "HistoricViewController"

    @IBOutlet weak var contentCollectionView: UICollectionView!
    var viewModel: HistoricViewModel!

    var baseCurrency: String!
    var targetCurrency: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        contentCollectionView.register(UINib(nibName: "HistoricRateCollectionViewCell", bundle: nil),
                                       forCellWithReuseIdentifier: "HistoricRateCollectionViewCell")

        viewModel = HistoricViewModel(baseCurrency: baseCurrency, targetCurrency: targetCurrency)
        subscribeFetchUpdates()
        viewModel.loadCurrencyHistory()
    }
    
    func updateUI() {
        contentCollectionView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HistoricViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoricRateCollectionViewCell",
                                                      for: indexPath) as! HistoricRateCollectionViewCell
        cell.set(info: viewModel.itemInfo(for: indexPath.item))
        return cell
    }
}

extension HistoricViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width,
                      height: HistoricRateCollectionViewCell.defaultSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}

extension HistoricViewController {
    func subscribeFetchUpdates() {
        viewModel.fetchStatusBlock = {[weak self] (status, error) in
            guard let weakSelf = self else {return}
            DispatchQueue.main.async {
                switch status {
                case .initiated:
                    break
                case .completed:
                    weakSelf.updateUI()
                    break
                case .failed:
                    break
                }
            }
        }
    }
}
