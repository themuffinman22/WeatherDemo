//
//  ExtendedForecast.swift
//  WeatherDemo
//
//  Created by Michael Leoniy on 12/16/24.
//

import Foundation

// overall struct for extendedForecast
struct ExtendedForecast: Codable {
    let properties: WeatherProperties
}

// struct containing periods
struct WeatherProperties: Codable {
    let units: String
    let forecastGenerator: String
    let generatedAt: String
    let updateTime: String
    let validTimes: String
    let elevation: Elevation
    let periods: [Period]
}

// needed for codable, wont use
struct Elevation: Codable {
    let unitCode: String
    let value: Double
}

// period is main struct used for data rendered in card rows and header
struct Period: Codable, CustomStringConvertible, Equatable {
    let number: Int
    let name: String
    let startTime: String
    let endTime: String
    let isDaytime: Bool
    let temperature: Int
    let temperatureUnit: String
    let temperatureTrend: String?
    let probabilityOfPrecipitation: ProbabilityOfPrecipitation?
    let windSpeed: String
    let windDirection: String
    let icon: String
    let shortForecast: String
    let detailedForecast: String
    
    // prettier display string on print
    var description: String {
        """
        ExtendedForecast(
            number: \(number),
            startTime: \(startTime),
            endTime: \(endTime),
            temperature: \(temperature),
            shortForecast: \(shortForecast),
        )
        """
    }
    
    // for equatable, needed for scrollview onChange to scroll to top
    static func ==(lhs: Period, rhs: Period) -> Bool {
        return lhs.number == rhs.number &&
               lhs.startTime == rhs.startTime &&
               lhs.endTime == rhs.endTime &&
               lhs.temperature == rhs.temperature &&
               lhs.temperatureUnit == rhs.temperatureUnit
    }
}

// may use
struct ProbabilityOfPrecipitation: Codable {
    let unitCode: String
    let value: Int?
}

// fetch for extended forecast, which is second api call necessary for complete forecast data
func fetchExtendedForecast(extendedForecastUrl: String, completion: @escaping (ExtendedForecast?) -> Void) {
    
    // url for second fetching of weather data
    guard let url = URL(string: "https://api.weather.gov/gridpoints/MTR/85,106/forecast") else {
        print("Invalid URL")
        completion(nil)
        return
    }
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error fetching weather data: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        guard let data = data else {
            print("No data received")
            completion(nil)
            return
        }
        
        do {
            let extendedForecast = try JSONDecoder().decode(ExtendedForecast.self, from: data)
            
            // got extended forecast, now complete
            completion(extendedForecast)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }
    task.resume()
}
