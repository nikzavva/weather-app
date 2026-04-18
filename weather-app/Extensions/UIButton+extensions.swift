//
//  UIButton+extensions.swift
//  weather-app
//
//  Created by Николай Завгородний on 20.09.2025.
//

import UIKit

extension UIButton {
    func setTitle(_ text: String, withMultiplier multiplier: CGFloat = 0.7) {
        let size = min(frame.height, frame.width) * multiplier

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: size, weight: .bold),
            .foregroundColor: UIColor.white
        ]
        let attributed = NSAttributedString(string: text, attributes: attributes)
        setAttributedTitle(attributed, for: .normal)
    }
    
    func round(cornerRadius: CGFloat? = nil) {
        layer.cornerRadius = cornerRadius ?? min(frame.height, frame.width) * 0.5
    }
}
