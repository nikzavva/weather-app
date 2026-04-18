//
//  UILabel+extensions.swift
//  weather-app
//
//  Created by Николай Завгородний on 20.09.2025.
//

import UIKit

extension UILabel {
    func setText(_ text: String, baseSize: CGFloat? = nil, multiplier: CGFloat, color: UIColor = .label) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: (baseSize ?? frame.height) * multiplier, weight: .bold),
            .foregroundColor: color
        ]

        let attributed = NSAttributedString(string: text, attributes: attributes)
        attributedText = attributed
    }
}
