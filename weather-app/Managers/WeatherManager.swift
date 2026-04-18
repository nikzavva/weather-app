//
//  WeatherManager.swift
//  weather-app
//
//  Created by Николай Завгородний on 21.09.2025.
//

import UIKit

final class WeatherManager {
    static let shared = WeatherManager()
    private init() {}
    
    private let url = "https://api.open-meteo.com/v1/forecast?"
        
    func getCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (CurrentWeatherResponce?) -> Void) {
        guard let url = URL(string: url + "latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code&timezone=auto") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, _ in
            guard let data else {
                completion(nil)
                return
            }
            
            completion(try? JSONDecoder().decode(CurrentWeatherResponce.self, from: data))
        }.resume()
    }
    
    func getHourlyWeather(latitude: Double, longitude: Double, completion: @escaping (HourlyWeatherResponce?) -> Void) {
        guard let url = URL(string: url + "latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,weather_code&timezone=auto&forecast_days=1") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, _ in
            guard let data else {
                completion(nil)
                return
            }
            
            completion(try? JSONDecoder().decode(HourlyWeatherResponce.self, from: data))
        }.resume()
    }
    
    func getSevenDaysWeather(latitude: Double, longitude: Double, completion: @escaping (SevenDaysWeatherResponce?) -> Void) {
        guard let url = URL(string: url + "latitude=\(latitude)&longitude=\(longitude)&daily=temperature_2m_max,relative_humidity_2m_max,wind_speed_10m_max,weather_code&timezone=auto&forecast_days=7") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, _ in
            guard let data else {
                completion(nil)
                return
            }
                        
            completion(try? JSONDecoder().decode(SevenDaysWeatherResponce.self, from: data))
        }.resume()
    }
}
