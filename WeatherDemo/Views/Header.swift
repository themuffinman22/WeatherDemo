//
//  Header.swift
//  WeatherDemo
//
//  Created by Michael Leoniy on 12/17/24.
//

import Foundation

// struct for Header
struct Header {
    var period: Period
    var location: RelativeLocationProperties
    
    // mocks to render in canvas
    static let distance = Distance(
        unitCode: "wmoUnit:m",
        value: 10750.196765434
    )
    
    static let bearing = Bearing(
        unitCode: "wmoUnit:degree_(angle)",
        value: 28.0
    )
    
    static let exampleLocation = RelativeLocationProperties(
        city: "Daly City",
        state: "CA",
        distance: distance,
        bearing: bearing
    )
    
    static let examplePeriod = Period(
        number: 1,
        name: "Today",
        startTime: "2024-12-17T09:00:00-08:00",
        endTime: "2024-12-17T18:00:00-08:00",
        isDaytime: true,
        temperature: 59,
        temperatureUnit: "F",
        temperatureTrend: "",
        probabilityOfPrecipitation: ProbabilityOfPrecipitation(
            unitCode: "wmoUnit:percent",
            value: nil
        ),
        windSpeed: "7 mph",
        windDirection: "NNW",
        icon: "https://api.weather.gov/icons/land/day/fog/sct?size=medium",
        shortForecast: "Areas Of Fog then Mostly Sunny",
        detailedForecast: "Areas of fog before 10am. Mostly sunny. High near 59, with temperatures falling to around 56 in the afternoon. North northwest wind around 7 mph."
    )
    static let example = Header(period: examplePeriod, location: exampleLocation)
}
