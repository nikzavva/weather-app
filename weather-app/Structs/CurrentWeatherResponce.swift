//
//  CurrentWeatherResponce.swift
//  weather-app
//
//  Created by Николай Завгородний on 20.09.2025.
//

struct CurrentWeatherResponce: Codable {
    let current: CurrentWeather
}

struct CurrentWeather: Codable {
    let temperature: Double
    let humidity: Int
    let windSpeed: Double
    let weatherCode: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temperature_2m"
        case humidity = "relative_humidity_2m"
        case windSpeed = "wind_speed_10m"
        case weatherCode = "weather_code"
    }
}
