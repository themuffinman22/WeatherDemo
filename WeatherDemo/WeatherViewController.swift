//
//  WeatherViewController.swift
//  WeatherDemo
//
//  Created by Michael Leoniy on 12/16/24.
//

import Foundation
import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var weatherForecast: WeatherForecast? // Hold forecast data
    
    // TODO: handle all transitory app states to reping location and get new data
    // good for demo purposes for now

    override func viewDidLoad() {
        super.viewDidLoad()
        // location delegate, request location and update
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // for when user grants or denies permission
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location access granted")
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied")
        case .notDetermined:
            print("Location permission not determined yet")
        @unknown default:
            print("Unknown authorization status")
        }
    }
    
    // called when user locations updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
                
        // fetch forecast for current location
        fetchWeatherForecast(latitude: latitude, longitude: longitude) { forecast in
            if let forecast = forecast {
                self.weatherForecast = forecast
                // update UI
                DispatchQueue.main.async {
                    self.updateWeatherUI(forecast: forecast)
                }
            }
        }
        // Stop updating location for battery
        locationManager.stopUpdatingLocation()
    }
    
    // stub come back to
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    // stub come back to
    func updateWeatherUI(forecast: WeatherForecast) {
        print("we got here!")
    }
}
