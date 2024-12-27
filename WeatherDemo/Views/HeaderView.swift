//
//  HeaderView.swift
//  WeatherDemo
//
//  Created by Michael Leoniy on 12/17/24.
//

import Foundation
import SwiftUI

// struct for Header
struct HeaderView: View {
    let header: Header
    @Binding var showSortOptions: Bool
    @State private var showingShortForecast: Bool = true // Tracks which forecast is displayed
    @State private var textSize: CGFloat = 20 // Initial font size for short forecast
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: { showSortOptions = true }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .opacity(0.8)
                    }
                }

                Text(header.location.city + ", " + header.location.state)
                    .font(.title)
                    .foregroundStyle(.black)
                
                HStack {
                    Text("\(header.period.temperature)°F")
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                    AsyncImage(url: URL(string: header.period.icon)) { image in
                        image
                            .resizable()
                            .frame(width: 34, height: 34)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    } placeholder: {
                        ProgressView()
                    }
                }
                .padding([.bottom], 10)
                
                HStack {
                    Text(showingShortForecast ? header.period.shortForecast : header.period.detailedForecast)
                        .font(.system(size: textSize))
                        .foregroundStyle(.secondary)
                        .lineLimit(nil)
                }
            }
            .padding([.horizontal, .bottom], 15)
            .padding([.top], 15)
            .clipped()
        }
        .frame(width: UIScreen.main.bounds.width)
        .fixedSize(horizontal: false, vertical: true)
        .background(
            UIBlurView(style: .systemMaterial)
                .shadow(radius: 10)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            // toggle between short and detailed forecasts
            // TODO: redo animation using geometryReader to get heights of short/detailed
            // text components onAppear and animate height of container and opacity of texts
            // with fixed origin to prevent moving vertically when view resizes.
            withAnimation(.easeInOut(duration: 0.275)) {
                showingShortForecast.toggle()
                textSize = showingShortForecast ? 20 : 18
            }
        }
    }
}

#Preview {
    HeaderView(header: .example, showSortOptions: .constant(false))
}


