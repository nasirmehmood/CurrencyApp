//
//  AppCoordinator.swift
//  Currency
//
//  Created by Light on 18/11/2022.
//

import Foundation
import UIKit

class AppCoordinator {
    static let shared = {
        return AppCoordinator(storyboard: UIStoryboard(name: "Main", bundle: nil))
    }()
    
    private var storyboard: UIStoryboard
    private var rootViewController: UIViewController!
    
    init(storyboard: UIStoryboard) {
        self.storyboard = storyboard
    }
    
    func start() {
        performBaseNavigation()
    }
    
    private func performBaseNavigation() {
        let controller: ConverterViewController = storyboard.instantiateViewController(withIdentifier: ConverterViewController.identifier) as! ConverterViewController
        controller.delegate = self
        let navigationController = UINavigationController(rootViewController: controller)
        rootViewController = navigationController        
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController = navigationController
    }
}

extension AppCoordinator: ConverterViewControllerDelegate {
    func converterViewController(_ controller: ConverterViewController, wantsToLoadDetailFor base: String, target: String, amount: Float) {
        
    }
}
