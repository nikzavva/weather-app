//
//  WeatherTableViewCell.swift
//  weather-app
//
//  Created by Николай Завгородний on 21.09.2025.
//

import UIKit

final class WeatherTableViewCell: UITableViewCell {
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var weatherIcon = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        contentView.addSubview(weatherIcon)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(contentView.snp.width).multipliedBy(0.75)
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
        }
        
        weatherIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing)
            make.trailing.equalTo(contentView.snp.trailing)
            make.width.equalTo(titleLabel.snp.height).priority(.low)
            make.width.lessThanOrEqualTo(titleLabel.snp.height)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.25)
            make.height.equalTo(weatherIcon.snp.width)
        }
    }
    
    func configure(with text: String, image: ImageResource, size: CGFloat) {
        weatherIcon.image = UIImage(resource: image)
        titleLabel.setText(text, baseSize: size, multiplier: 0.1)
    }
}
