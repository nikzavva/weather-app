//
//  WeatherViewModel.swift
//  weather-app
//
//  Created by Николай Завгородний on 21.09.2025.
//

import UIKit

class WeatherViewModel {
    var locality = Locality()
    var currentWeather = Bindable<CurrentWeather?>(nil)
    var hourlyWeather = Bindable<HourlyWeatherResponce?>(nil)
    var sevenDaysWeather = Bindable<SevenDaysWeatherResponce?>(nil)
    var isLoading = Bindable<Bool>(true)
    
    func loadWeather() {
        isLoading.value = true
        
        WeatherManager.shared.getCurrentWeather(latitude: locality.latitude, longitude: locality.longitude, completion: { [weak self] weather in
            guard let weather else { return }
            DispatchQueue.main.async {
                self?.currentWeather.value = weather.current
            }
        })
        
        WeatherManager.shared.getHourlyWeather(latitude: locality.latitude, longitude: locality.longitude) { [weak self] weather in
            guard let weather else { return }
            DispatchQueue.main.async {
                self?.hourlyWeather.value = weather
            }
        }
        
        WeatherManager.shared.getSevenDaysWeather(latitude: locality.latitude, longitude: locality.longitude) { [weak self] weather in
            guard let weather else { return }
            DispatchQueue.main.async {
                self?.sevenDaysWeather.value = weather
                self?.isLoading.value = false
            }
        }
    }
    
    func getImageName(from code: Int) -> ImageResource {
        var image: ImageResource
        
        switch code {
        case 0:
            image = .sun
        case 1, 2, 3:
            image = .cloud
        case 45, 48:
            image = .fog
        case 51, 53, 55:
            image = .drizzly
        case 61, 63, 65:
            image = .rain
        case 71, 73, 75:
            image = .snow
        case 77:
            image = .hail
        case 80, 81, 82:
            image = .rainfall
        case 85, 86:
            image = .snowfall
        case 95, 96, 99:
            image = .thunderstorm
        default:
            image = .question
        }
        
        return image
    }
}
