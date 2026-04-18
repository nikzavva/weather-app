//
//  ViewController.swift
//  weather-app
//
//  Created by Николай Завгородний on 19.09.2025.
//

import UIKit
import SnapKit
import CoreLocation

final class ChooseLocalityViewController: UIViewController {
        
    private lazy var stackView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var textField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .words
        textField.clearButtonMode = .whileEditing
        textField.adjustsFontSizeToFitWidth = true
        textField.delegate = self
        return textField
    }()
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.bouncesVertically = false
        tableView.separatorStyle = .none
        tableView.register(LocalityTableViewCell.self, forCellReuseIdentifier: "LocalityCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var getLocationButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    private lazy var nextButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    private let viewModel = ChooseLocalityViewModel()
    private var searchResults: [CLPlacemark] = []
    
    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reset()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure()
    }
    
    @objc private func getLocationButtonPressed() {
        viewModel.getCurrentGeolocation()
    }
    
    @objc private func nextButtonPressed() {
        guard let locality = viewModel.locality.value else { return }
        coordinator?.openWeatherVC(withLocality: locality)
    }
    
    private func setupInitialState() {
        setupView()
        setupConstraints()
        bindViewModel()
        viewModel.setupLocationManager()
    }
    
    private func reset() {
        viewModel.resetState()
        textField.text = ""
        tableView.reloadData()
    }
    
    private func configure() {
        getLocationButton.round()
        nextButton.round()
        getLocationButton.setTitle("Location".localize())
        nextButton.setTitle("Next".localize())
        textField.setPlaceholder("Enter a locality".localize())
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        getLocationButton.addTarget(self, action: #selector(getLocationButtonPressed), for: .touchUpInside)
        
        [textField, tableView, getLocationButton, nextButton].forEach { stackView.addSubview($0) }
    }
    
    private func setupConstraints() {
        let textFieldHeightRatio: CGFloat = 0.05
        let halfTextFieldHeight = view.bounds.height * textFieldHeightRatio / 2
        
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        textField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(textFieldHeightRatio)
            make.centerX.equalToSuperview()
            make.top.equalTo(stackView.snp.top)
        }
        
        nextButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(textField.snp.height)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(stackView.snp.bottom)
        }
        
        getLocationButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(textField.snp.height)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-halfTextFieldHeight)
        }

        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(textField.snp.bottom).offset(halfTextFieldHeight)
            make.bottom.equalTo(getLocationButton.snp.top).offset(-textFieldHeightRatio * view.frame.height)
        }
    }
    
    private func bindViewModel() {
        viewModel.searchResults.bind { [weak self] results in
            self?.searchResults = results
            self?.tableView.reloadData()
        }
        
        viewModel.isTableHidden.bind { [weak self] isHidden in
            self?.tableView.isHidden = isHidden
        }
        
        viewModel.selectedCityName.bind { [weak self] cityName in
            self?.textField.text = cityName
        }
    }
}

extension ChooseLocalityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocalityCell", for: indexPath) as? LocalityTableViewCell else { return UITableViewCell() }
        let placemark = searchResults[indexPath.row]
        cell.configure(with: viewModel.getLocationText(placemark), size: view.frame.width, isPad: UserDeviceManager.shared.isPad)
        return cell
    }
}

extension ChooseLocalityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.selectPlacemark(at: indexPath.row)
        tableView.isHidden = true
        textField.resignFirstResponder()
    }
}

extension ChooseLocalityViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        viewModel.searchIfNeeded(with: updatedText)
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        viewModel.showTableIfResultsAvailable()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewModel.showTableIfResultsAvailable()
    }
}
