//
//  UITextField+extensions.swift
//  weather-app
//
//  Created by Николай Завгородний on 21.09.2025.
//

import UIKit

extension UITextField {
    func setPlaceholder(_ text: String, multiplier: CGFloat = 0.5) {
        let size = frame.height * multiplier
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: size),
            .foregroundColor: UIColor.gray
        ]
        
        attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
        font = UIFont.systemFont(ofSize: size)
    }
}
