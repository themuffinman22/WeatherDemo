//
//  WeatherViewModel.swift
//  WeatherDemo
//
//  Created by Michael Leoniy on 12/16/24.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published var weatherForecast: WeatherForecast?
    @Published var extendedForecast: ExtendedForecast?
    
    // fetch initial weather, need 2 api calls to noaa
    func fetchWeatherForecast(latitude: Double, longitude: Double) {
        WeatherDemo.fetchWeatherForecast(latitude: latitude, longitude: longitude) { forecast in
            DispatchQueue.main.async {
                self.weatherForecast = forecast
                if let extendedForecastUrl = forecast?.properties.forecast {
                    self.fetchExtendedForecast(extendedForecastUrl: extendedForecastUrl)
                }
            }
        }
    }
    
    // second fetch, to get periods
    func fetchExtendedForecast(extendedForecastUrl: String) {
        WeatherDemo.fetchExtendedForecast(extendedForecastUrl: extendedForecastUrl) { extendedForecast in
            DispatchQueue.main.async {
                self.extendedForecast = extendedForecast
            }
        }
    }
}
