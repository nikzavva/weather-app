//
//  LocalityTableViewCell.swift
//  weather-app
//
//  Created by Николай Завгородний on 20.09.2025.
//

import UIKit

final class LocalityTableViewCell: UITableViewCell {
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
    }
    
    func configure(with text: String, size: CGFloat, isPad: Bool) {
        titleLabel.setText(text, baseSize: size, multiplier: isPad ? 0.06 : 0.08)
    }
}
