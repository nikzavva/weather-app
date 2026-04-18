//
//  MainCoordinator.swift
//  weather-app
//
//  Created by Николай Завгородний on 19.09.2025.
//

import UIKit

final class MainCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ChooseLocalityViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func openWeatherVC(withLocality locality: Locality) {
        let vc = WeatherViewController()
        vc.coordinator = self
        vc.configure(withLocality: locality)
        navigationController.pushViewController(vc, animated: true)
    }
}
