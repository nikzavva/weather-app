//
//  HourlyWeatherResponce.swift
//  weather-app
//
//  Created by Николай Завгородний on 27.09.2025.
//

struct HourlyWeatherResponce: Codable {
    let hourly: Hourly
}

struct Hourly: Codable {
    let time: [String]
    let temperature: [Double]
    let weatherCode: [Int]
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case weatherCode = "weather_code"
    }
}
