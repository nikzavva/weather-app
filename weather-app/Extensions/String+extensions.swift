//
//  String+extensions.swift
//  weather-app
//
//  Created by Николай Завгородний on 20.09.2025.
//

import UIKit

extension String {
    func localize() -> String {
        NSLocalizedString(self, comment: "")
    }
}
