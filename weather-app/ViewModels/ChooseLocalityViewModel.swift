//
//  ChooseLocalityViewModel.swift
//  weather-app
//
//  Created by Николай Завгородний on 20.09.2025.
//

import CoreLocation

final class ChooseLocalityViewModel: NSObject {
    
    var searchResults = Bindable<[CLPlacemark]>([])
    var isTableHidden = Bindable<Bool>(true)
    var locality = Bindable<Locality?>(nil)
    var selectedCityName = Bindable<String>("")
    
    private let locationManager = CLLocationManager()
    private let nonCity = "Unknown city".localize()

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func resetState() {
        searchResults.value = []
        isTableHidden.value = true
        locality.value = nil
        selectedCityName.value = ""
    }
    
    func getCurrentGeolocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func showTableIfResultsAvailable() {
        isTableHidden.value = searchResults.value.isEmpty
    }
    
    func getLocationText(_ placemark: CLPlacemark) -> String {
        var displayText = placemark.locality ?? nonCity

        if let administrativeArea = placemark.administrativeArea {
            displayText += ", \(administrativeArea)"
        }
        if let country = placemark.country {
            displayText += ", \(country)"
        }
        
        return displayText
    }
    
    func selectPlacemark(at index: Int) {
        let selectedPlacemark = searchResults.value[index]
        
        if let location = selectedPlacemark.location {
            let coordinate = location.coordinate
            let cityName = selectedPlacemark.locality ?? nonCity
            
            selectedCityName.value = cityName
            locality.value = Locality(placeName: cityName, latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
    
    func searchIfNeeded(with query: String) {
        if query.count > 2 {
            searchForLocation(with: query)
        } else {
            searchResults.value = []
            isTableHidden.value = true
        }
    }
    
    private func searchForLocation(with query: String) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(query) { [weak self] placemarks, error in
            guard let self else { return }
            
            if let error {
                print("Geocoding error: \(error.localizedDescription)")
                self.searchResults.value = []
                self.isTableHidden.value = true
                return
            }
            
            self.searchResults.value = placemarks?.compactMap { $0 } ?? []
            self.isTableHidden.value = self.searchResults.value.isEmpty
        }
    }
    
    private func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self else { return }
            
            if let error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            
            self.searchResults.value = [placemark]
            self.isTableHidden.value = self.searchResults.value.isEmpty
        }
    }
}

extension ChooseLocalityViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let location = manager.location else { return }
        reverseGeocode(location: location)
    }
}
