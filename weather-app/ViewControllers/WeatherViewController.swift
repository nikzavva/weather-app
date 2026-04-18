//
//  WeatherViewController.swift
//  weather-app
//
//  Created by Николай Завгородний on 20.09.2025.
//

import UIKit

class WeatherViewController: UIViewController {
    
    private lazy var placeNameLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private lazy var temperatureLabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var humidityAndTemperatureStackView = {
        let view = UIView()
        return view
    }()
    
    private lazy var humidityTitleLabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var windSpeedTitleLabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var humidityLabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var windSpeedLabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.bouncesHorizontally = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "WeatherCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var collectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.bouncesVertically = false
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private let viewModel = WeatherViewModel()
    private var hourlyWeather: HourlyWeatherResponce?
    private var sevenDaysWeather: SevenDaysWeatherResponce?
    private var mainBlur: UIVisualEffectView?
    private var mainActivityIndicator: UIActivityIndicatorView?
    
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setFonts()
    }
    
    private func setupInitialState() {
        bindViewModel()
        setupView()
        setupConstraints()
        setSwipe()
        viewModel.loadWeather()
    }
    
    private func setFonts() {
        humidityTitleLabel.setText("Humidity:".localize(), multiplier: 0.7)
        windSpeedTitleLabel.setText("Wind:".localize(), multiplier: 0.7)
    }
    
    private func setSwipe() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        [placeNameLabel, temperatureLabel, humidityAndTemperatureStackView, collectionView, tableView].forEach { view.addSubview($0) }
        [humidityTitleLabel, windSpeedTitleLabel, humidityLabel, windSpeedLabel].forEach { humidityAndTemperatureStackView.addSubview($0) }
    }
    
    private func setupConstraints() {
        let placeNameLabelHeightRatio = 0.08
        let halfPlaceNameLabelHeight = view.frame.height * placeNameLabelHeightRatio / 2
        
        placeNameLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(placeNameLabelHeightRatio)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.size.equalTo(placeNameLabel.snp.size)
            make.centerX.equalToSuperview()
            make.top.equalTo(placeNameLabel.snp.bottom)
        }
        
        humidityAndTemperatureStackView.snp.makeConstraints { make in
            make.width.equalTo(temperatureLabel.snp.width)
            make.height.equalTo(temperatureLabel.snp.height).multipliedBy(1.5)
            make.centerX.equalToSuperview()
            make.top.equalTo(temperatureLabel.snp.bottom)
        }
        
        humidityTitleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.top.equalTo(humidityAndTemperatureStackView.snp.top)
            make.leading.equalTo(humidityAndTemperatureStackView.snp.leading)
        }
        
        windSpeedTitleLabel.snp.makeConstraints { make in
            make.size.equalTo(humidityTitleLabel.snp.size)
            make.top.equalTo(humidityAndTemperatureStackView.snp.top)
            make.trailing.equalTo(humidityAndTemperatureStackView.snp.trailing)
        }
        
        humidityLabel.snp.makeConstraints { make in
            make.size.equalTo(humidityTitleLabel.snp.size)
            make.top.equalTo(humidityTitleLabel.snp.bottom)
            make.leading.equalTo(humidityAndTemperatureStackView.snp.leading)
        }
        
        windSpeedLabel.snp.makeConstraints { make in
            make.size.equalTo(windSpeedTitleLabel.snp.size)
            make.top.equalTo(windSpeedTitleLabel.snp.bottom)
            make.trailing.equalTo(humidityAndTemperatureStackView.snp.trailing)
        }
        
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(humidityAndTemperatureStackView.snp.height).multipliedBy(1.5)
            make.leading.equalToSuperview().offset(halfPlaceNameLabelHeight * 0.5)
            make.trailing.equalToSuperview().offset(-halfPlaceNameLabelHeight * 0.5)
            make.centerX.equalToSuperview()
            make.top.equalTo(humidityAndTemperatureStackView.snp.bottom).offset(halfPlaceNameLabelHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(halfPlaceNameLabelHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func configure(withLocality newLocality: Locality) {
        viewModel.locality = newLocality
    }
    
    private func bindViewModel() {
        viewModel.isLoading.bind { [weak self] isLoading in
            isLoading ? self?.showLoading() : self?.setBlurAndIndicator(isDeleted: true)
        }
        
        viewModel.currentWeather.bind { [weak self] current in
            guard let self, let current else { return }
            placeNameLabel.setText(viewModel.locality.placeName, multiplier: 0.6)
            temperatureLabel.setText("\(Int(current.temperature)) °C", multiplier: 0.75)
            humidityLabel.setText("\(current.humidity)%", multiplier: 0.8)
            windSpeedLabel.setText("\(Int(current.windSpeed)) " + "km/h".localize(), multiplier: 0.8)
        }
        
        viewModel.hourlyWeather.bind { [weak self] weather in
            self?.hourlyWeather = weather
            self?.collectionView.reloadData()
        }
        
        viewModel.sevenDaysWeather.bind { [weak self] weather in
            self?.sevenDaysWeather = weather
            self?.tableView.reloadData()
        }
    }
    
    private func showLoading() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blur = UIVisualEffectView(effect: blurEffect)
        blur.frame = view.bounds
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.frame = blur.bounds
        activityIndicator.startAnimating()
        
        setBlurAndIndicator(blur: blur, activityIndicator: activityIndicator)
        
        view.addSubview(blur)
        view.addSubview(activityIndicator)
    }
    
    private func setBlurAndIndicator(blur: UIVisualEffectView? = nil, activityIndicator: UIActivityIndicatorView? = nil, isDeleted: Bool = false) {
        if isDeleted {
            mainBlur?.removeFromSuperview()
            mainActivityIndicator?.removeFromSuperview()
        }
        
        mainBlur = blur
        mainActivityIndicator = activityIndicator
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let hourlyWeather else { return 0 }
        return hourlyWeather.hourly.time.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCollectionViewCell else { return UICollectionViewCell() }
        guard let hourlyWeather else { return cell }
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:00"

        if let date = inputFormatter.date(from: hourlyWeather.hourly.time[indexPath.item]) {
            let formattedDate = outputFormatter.string(from: date)
            let temperature = "\(Int(hourlyWeather.hourly.temperature[indexPath.item])) °C"
            let weatherImage = viewModel.getImageName(from: hourlyWeather.hourly.weatherCode[indexPath.item])
            
            cell.configure(hour: formattedDate, image: weatherImage, degrees: temperature, size: view.frame.width, isPad: UserDeviceManager.shared.isPad)
        }
        
        return cell
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = collectionView.frame.height
        return CGSize(width: side * 0.5, height: side)
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        guard let sevenDaysWeather else { return cell }
        var displayText = ""
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM"

        if let date = inputFormatter.date(from: sevenDaysWeather.daily.time[indexPath.row]) {
            let formattedDate = outputFormatter.string(from: date)
            displayText += "\(formattedDate) "
        }
        
        displayText += "\(Int(sevenDaysWeather.daily.temperature[indexPath.row])) °C\n \(sevenDaysWeather.daily.humidity[indexPath.row])% \(Int(sevenDaysWeather.daily.windSpeed[indexPath.row])) " + "km/h".localize()

        cell.configure(with: displayText, image: viewModel.getImageName(from: sevenDaysWeather.daily.weatherCode[indexPath.row]), size: view.frame.width)
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Forecast for 7 days".localize()
    }
}
