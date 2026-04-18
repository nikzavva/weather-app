//
//  SevenDaysWeatherResponce.swift
//  weather-app
//
//  Created by Николай Завгородний on 20.09.2025.
//

struct SevenDaysWeatherResponce: Codable {
    let daily: Daily
}

struct Daily: Codable {
    let time: [String]
    let temperature: [Double]
    let humidity: [Int]
    let windSpeed: [Double]
    let weatherCode: [Int]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m_max"
        case humidity = "relative_humidity_2m_max"
        case windSpeed = "wind_speed_10m_max"
        case weatherCode = "weather_code"
    }
}
