//
//  Locality.swift
//  weather-app
//
//  Created by Николай Завгородний on 20.09.2025.
//

struct Locality {
    let placeName: String
    let latitude: Double
    let longitude: Double
    
    init(placeName: String, latitude: Double, longitude: Double) {
        self.placeName = placeName
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init() {
        self.placeName = ""
        self.latitude = 0
        self.longitude = 0
    }
}
