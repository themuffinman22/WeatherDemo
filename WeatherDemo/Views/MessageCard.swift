//
//  MessageCard.swift
//  WeatherDemo
//
//  Created by Michael Leoniy on 12/18/24.
//

import Foundation

// struct for MessageCard
struct MessageCard {
    var message: String
    var isLoading: Bool
    
    // mocks to render in canvas
    static let example = MessageCard(message: "Fetching Weather Forecast...", isLoading: true)
}
