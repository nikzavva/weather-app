//
//  WeatherCollectionViewCell.swift
//  weather-app
//
//  Created by Николай Завгородний on 21.09.2025.
//

import UIKit
import SnapKit

final class WeatherCollectionViewCell: UICollectionViewCell {
  
    private lazy var hourLabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var temperatureLabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var weatherIcon = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        resetCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    private func resetCell() {
        hourLabel.text = nil
        hourLabel.font = UIFont.systemFont(ofSize: 0)
        temperatureLabel.text = nil
        temperatureLabel.font = UIFont.systemFont(ofSize: 0)
        weatherIcon.image = nil
    }
    
    private func setupView() {
        contentView.backgroundColor = .systemBlue
        contentView.layer.cornerRadius = 10
        
        contentView.addSubview(hourLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(weatherIcon)
    }
    
    private func setupConstraints() {
        hourLabel.snp.makeConstraints { make in
            make.width.equalTo(contentView.snp.width)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.2)
            make.top.equalTo(contentView.snp.top)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.width.equalTo(contentView.snp.width)
            make.height.equalTo(hourLabel.snp.height)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        weatherIcon.snp.makeConstraints { make in
            make.top.equalTo(hourLabel.snp.bottom)
            make.bottom.equalTo(temperatureLabel.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
    }
    
    func configure(hour: String, image: ImageResource, degrees: String, size: CGFloat, isPad: Bool) {
        weatherIcon.image = UIImage(resource: image)
        hourLabel.setText(hour, baseSize: size, multiplier: isPad ? 0.04 : 0.055, color: .white)
        temperatureLabel.setText(degrees, baseSize: size, multiplier: isPad ? 0.04 : 0.055, color: .white)
    }
}
