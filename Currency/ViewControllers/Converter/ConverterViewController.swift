//
//  ViewController.swift
//  Currency
//
//  Created by Nasir Mehmood on 18/11/2022.
//

import UIKit
import DropDown

protocol ConverterViewControllerDelegate: AnyObject {
    func converterViewController(_ controller: ConverterViewController, wantsToLoadDetailFor baseCurrency: String, targetCurrency: String)
}

class ConverterViewController: UIViewController {
    
    static let identifier = "ConverterViewController"

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var targetCurrencyButton: UIButton!
    @IBOutlet weak var baseCurrencyButton: UIButton!
    @IBOutlet weak var swapCurrencyButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var baseCurrencyTextField: UITextField!
    
    @IBOutlet weak var targetCurrencyTextField: UITextField!
    @IBOutlet weak var retryButton: UIButton!
    
    weak var delegate: ConverterViewControllerDelegate? = nil
    var viewModel: ConvertViewModel = ConvertViewModel()
    
    let dropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.width = 100
        return dropDown
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        retryButton.layer.cornerRadius = 12
        detailsButton.layer.cornerRadius = 12
        
        baseCurrencyTextField.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: .editingDidBegin)
        baseCurrencyTextField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        subscribeCurrencySelectionUpdates()
        subscribeCurrencyConversionUpdates()
        updateUI()
    }

    func updateUI() {
        resetUI()
        baseCurrencyButton.setTitle(viewModel.baseCurrency ?? "--", for: .normal)
        targetCurrencyButton.setTitle(viewModel.targetCurrency ?? "--", for: .normal)
        baseCurrencyTextField.text = String(format: "%0.2f", viewModel.baseAmount)
        targetCurrencyTextField.text = String(format: "%0.2f", viewModel.targetAmount)
    }
    
    func resetUI() {
        detailsButton.isHidden = true
        retryButton.isHidden = true
    }
    
    func showLoadingView() {
        activityIndicatorView.isHidden = false
    }
    
    func hideLoadingView() {
        activityIndicatorView.isHidden = true
    }
    
//MARK: - IBAction Methods
    @IBAction func baseCurrencyButtonClicked(_ sender: Any) {
        dropDown.dataSource = viewModel.currenciesList
        dropDown.anchorView = baseCurrencyButton
        dropDown.show()
    }
    
    @IBAction func targetCurrencyButtonClicked(_ sender: Any) {
        dropDown.dataSource = viewModel.currenciesList
        dropDown.anchorView = targetCurrencyButton
        dropDown.show()
    }
    
    @IBAction func swapCurrencyButtonClicked(_ sender: Any) {
        viewModel.toggleCurrency()
    }

    @IBAction func detailsButtonClicked(_ sender: Any) {
        if let delegate = delegate,
           let baseCurrency = viewModel.baseCurrency,
           let targetCurrency = viewModel.targetCurrency {
            let baseAmount = viewModel.baseAmount
            delegate.converterViewController(self,
                                             wantsToLoadDetailFor: baseCurrency,
                                             targetCurrency: targetCurrency)
        }
    }
    
    @IBAction func retryButtonClicked(_ sender: Any) {
        viewModel.performConversion()
    }
}

extension ConverterViewController {
    @objc func textFieldEditingDidBegin(_ sender: UITextField) {
        if viewModel.baseAmount == 0 {
            baseCurrencyTextField.text = ""
        }
    }

    @objc func textFieldEditingDidEnd(_ sender: UITextField) {
        viewModel.baseAmount = Float(baseCurrencyTextField.text ?? "") ?? 0.0
        updateUI()
        viewModel.performConversion()
    }
}

extension ConverterViewController {
    func subscribeCurrencyConversionUpdates() {
        viewModel.fetchStatusBlock = {[weak self] status, error in
            guard let weakSelf = self else {return}
            DispatchQueue.main.async {
                switch status {
                case .initiated:
                    weakSelf.showLoadingView()
                    weakSelf.resetUI()
                    break
                case .completed:
                    weakSelf.hideLoadingView()
                    weakSelf.updateUI()
                    weakSelf.detailsButton.isHidden = false
                    break
                case .failed:
                    weakSelf.hideLoadingView()
                    weakSelf.resetUI()
                    weakSelf.retryButton.isHidden = false
                    if let error = error {
                        weakSelf.showErrorAlert(msg: error.localizedDescription)
                    }
                    break
                }
            }
        }
    }

    func subscribeCurrencySelectionUpdates() {
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if self.dropDown.anchorView?.plainView == baseCurrencyButton {
                self.viewModel.baseCurrency = item
            } else {
                self.viewModel.targetCurrency = item
            }
            
            DispatchQueue.main.async {
                self.updateUI()
                self.viewModel.performConversion()
            }
        }
    }
    
    func showErrorAlert(msg: String) {
        let alertController = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
