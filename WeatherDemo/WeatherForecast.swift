//
//  WeatherForecast.swift
//  WeatherDemo
//
//  Created by Michael Leoniy on 12/16/24.
//

import Foundation

// overall struct for weatherForecast
struct WeatherForecast: Codable, CustomStringConvertible {
    let context: [ContextElement]
    let id: String
    let type: String
    let geometry: Geometry
    let properties: Properties
    
    enum CodingKeys: String, CodingKey {
        case context = "@context"
        case id
        case type
        case geometry
        case properties
    }
    
    // prettier display string on print
    var description: String {
        """
        WeatherForecast(
            id: \(id),
            type: \(type),
            geometry: \(geometry),
            properties: \(properties)
        )
        """
    }
}

// handles both string and objects
enum ContextElement: Codable, CustomStringConvertible {
    case string(String)
    case object([String: ContextValue])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let objectValue = try? container.decode([String: ContextValue].self) {
            self = .object(objectValue)
        } else {
            throw DecodingError.typeMismatch(
                ContextElement.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Context element is not a string or an object"
                )
            )
        }
    }
    
    // safe encode
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .object(let value):
            try container.encode(value)
        }
    }
    
    // prettier display string on print
    var description: String {
        switch self {
        case .string(let value):
            return "\"\(value)\""
        case .object(let value):
            return "Object(\(value))"
        }
    }
}

// handles both string and objects
enum ContextValue: Codable, CustomStringConvertible {
    case string(String)
    case object([String: String])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let objectValue = try? container.decode([String: String].self) {
            self = .object(objectValue)
        } else {
            throw DecodingError.typeMismatch(
                ContextValue.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Context value is not a string or an object"
                )
            )
        }
    }
    
    // safe encode
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .object(let value):
            try container.encode(value)
        }
    }
    
    // prettier display string on print
    var description: String {
        switch self {
        case .string(let value):
            return value
        case .object(let value):
            return "\(value)"
        }
    }
}

// needed for codable, wont use
struct Geometry: Codable, CustomStringConvertible {
    let type: String
    let coordinates: [Double]
    
    // prettier display string on print
    var description: String {
        "Geometry(type: \(type), coordinates: \(coordinates))"
    }
}

// properties struct
struct Properties: Codable, CustomStringConvertible {
    let id: String
    let type: String
    let cwa: String
    let forecastOffice: String
    let gridId: String
    let gridX: Int
    let gridY: Int
    let forecast: String
    let forecastHourly: String
    let forecastGridData: String
    let observationStations: String
    let relativeLocation: RelativeLocation
    let forecastZone: String
    let county: String
    let fireWeatherZone: String
    let timeZone: String
    let radarStation: String
    
    enum CodingKeys: String, CodingKey {
        case id = "@id"
        case type = "@type"
        case cwa
        case forecastOffice
        case gridId
        case gridX
        case gridY
        case forecast
        case forecastHourly
        case forecastGridData
        case observationStations
        case relativeLocation
        case forecastZone
        case county
        case fireWeatherZone
        case timeZone
        case radarStation
    }
    
    // prettier display string on print
    var description: String {
        """
        Properties(
            id: \(id),
            forecast: \(forecast),
            relativeLocation: \(relativeLocation)
        )
        """
    }
}

// struct needed for city, state
struct RelativeLocation: Codable, CustomStringConvertible {
    let type: String
    let geometry: Geometry
    let properties: RelativeLocationProperties
    
    // prettier display string on print
    var description: String {
        "RelativeLocation(city: \(properties.city), state: \(properties.state))"
    }
}

// additional struct needed for city state
struct RelativeLocationProperties: Codable, CustomStringConvertible {
    let city: String
    let state: String
    let distance: Distance
    let bearing: Bearing
    
    // prettier display string on print
    var description: String {
        "Properties(city: \(city), state: \(state))"
    }
}

// needed for codable, wont use
struct Distance: Codable, CustomStringConvertible {
    let unitCode: String
    let value: Double
    
    // prettier display string on print
    var description: String {
        "Distance(value: \(value) \(unitCode))"
    }
}

// needed for codable, wont use
struct Bearing: Codable, CustomStringConvertible {
    let unitCode: String
    let value: Double
    
    // prettier display string on print
    var description: String {
        "Bearing(value: \(value) \(unitCode))"
    }
}

// Function to fetch weather data from NOAA API
func fetchWeatherForecast(latitude: Double, longitude: Double, completion: @escaping (WeatherForecast?) -> Void) {
    
    // url for first fetching of weather data
    guard let url = URL(string: "https://api.weather.gov/points/\(latitude),\(longitude)") else {
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
            let forecast = try JSONDecoder().decode(WeatherForecast.self, from: data)
            
            // got forecast, now complete
            completion(forecast)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }
    task.resume()
}

