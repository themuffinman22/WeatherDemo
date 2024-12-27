//
//  LocationManager.swift
//  WeatherDemo
//
//  Created by Michael Leoniy on 12/16/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation? // hold current location
    @Published var locationStatus: CLAuthorizationStatus?
    
    private let locationManager = CLLocationManager()
    var weatherViewModel: WeatherViewModel?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // request user location permission
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // pass model to LM to fetch weather data
    func setWeatherViewModel(weatherViewModel: WeatherViewModel) {
        self.weatherViewModel = weatherViewModel
    }
}

// CLLocationManagerDelegate extensions
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        location = newLocation
        locationManager.stopUpdatingLocation() // Save battery, stop location updates
        
        // fetch when location updates
        if let latitude = location?.coordinate.latitude, let longitude = location?.coordinate.longitude {
            weatherViewModel?.fetchWeatherForecast(latitude: latitude, longitude: longitude)
        }
    }
    // for error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}
