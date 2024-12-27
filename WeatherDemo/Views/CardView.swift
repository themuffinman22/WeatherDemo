//
//  CardView.swift
//  WeatherDemo
//
//  Created by Michael Leoniy on 12/17/24.
//

import Foundation
import SwiftUI

// CardView is the row rendered below the header
struct CardView: View {
    let card: Card
    
    var body: some View {
        ZStack {
            UIBlurView(style: .systemMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 10)
                .frame(width: UIScreen.main.bounds.width * 0.95)
                .padding(.top, 10)
            
            VStack {
                // row for day and temp and icon
                HStack {
                    Text(card.period.name)
                        .font(.title)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Text("\(card.period.temperature)°F")
                        .font(.title)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                    AsyncImage(url: URL(string: card.period.icon)) { image in
                        image
                            .resizable()
                            .frame(width: 28, height: 28)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    } placeholder: {
                        ProgressView()
                    }
                }
                // row for forecast
                HStack {
                    Text(card.period.shortForecast)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                    Spacer()
                }
            }
            .padding([.horizontal], 25)
            .padding([.bottom], 10)
            .padding([.top], 20)
        }
    }
}

#Preview {
    CardView(card: .example)
}

