//
//  WeatherView.swift
//  WeatherDemo
//
//  Created by Michael Leoniy on 12/16/24.
//

import SwiftUI
import CoreLocation

enum SortOption {
    case mostRecent
    case leastRecent
    case highestTemp
    case lowestTemp
}

// main view after entry point
struct WeatherView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var weatherViewModel = WeatherViewModel()
    @State private var showSortOptions = false // popover state
    @State private var sortedPeriods: [Period] = [] // sorted periods state
    
    var body: some View {
        VStack(spacing: 0) {
            if let _ = locationManager.location { // check for location but dont need as var
                if let periods = weatherViewModel.extendedForecast?.properties.periods,
                   let locationProps = weatherViewModel.weatherForecast?.properties.relativeLocation.properties {
                
                    // header for forecast
                    HeaderView(header: Header(
                        period: periods[0],
                        location: locationProps
                    ),
                    showSortOptions: $showSortOptions)
                    .zIndex(1) // so shadow overlays scrollview content when overlapping
                    
                    // reader for scrollToTop onChange
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack{
                                ForEach(sortedPeriods, id: \.number) { period in
                                    CardView(card: Card(period: period))
                                        .id(period.number) // need id for onChange
                                }
                            }
                            .padding(.bottom)
                        }
                        .onChange(of: sortedPeriods) { _, newSortedPeriods in
                            // scroll to top on sort change
                            if let firstPeriod = newSortedPeriods.first {
                                proxy.scrollTo(firstPeriod.number, anchor: .top)
                            }
                        }
                        .onAppear {
                            // default
                            sortPeriods(by: .mostRecent)
                        }
                        .scrollIndicators(.never)
                    }
                } else {
                    // fetching forecast message
                    MessageCardView(messageCard: MessageCard(message: "Fetching Weather Forecast...", isLoading: true))
                }
            } else if locationManager.locationStatus == .denied {
                // enable location permission message
                MessageCardView(messageCard: MessageCard(
                    message: "Location Access Denied.\nPlease Enable it in Settings.",
                    isLoading: false
                ))
            } else {
                // requesting location message
                MessageCardView(messageCard: MessageCard(message: "Requesting Location...", isLoading: true))
            }
        }
        .onAppear {
            // request location onAppear and pass WeatherViewModel to LocationManager
            locationManager.requestLocation()
            locationManager.setWeatherViewModel(weatherViewModel: weatherViewModel)
        }
        .background(
            // pretty gradient
            LinearGradient(
                gradient: Gradient(colors: [.blue, .purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        // popover for sorting
        .popover(isPresented: $showSortOptions) {
            ZStack {
                Color.blue.opacity(0.3)
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                UIBlurView(style: .systemMaterial)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    Text("Sort Forecast By:")
                        .font(.title2)
                        .padding()
                        .bold()
                    
                    Divider()
                        .frame(width: UIScreen.main.bounds.width * 0.6)
                    
                    Button("Most Recent Forecast") {
                        sortPeriods(by: .mostRecent)
                        showSortOptions = false
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    .font(.title3)
                    
                    Button("Least Recent Forecast") {
                        sortPeriods(by: .leastRecent)
                        showSortOptions = false
                    }
                    .padding(.vertical, 10)
                    .font(.title3)
                    
                    Button("Highest Temperature") {
                        sortPeriods(by: .highestTemp)
                        showSortOptions = false
                    }
                    .padding(.vertical, 10)
                    .font(.title3)
                    
                    Button("Lowest Temperature") {
                        sortPeriods(by: .lowestTemp)
                        showSortOptions = false
                    }
                    .padding(.vertical, 10)
                    .font(.title3)
                    
                    Button("Close") {
                        showSortOptions = false
                    }
                    .padding(.vertical, 30)
                    .font(.title3)
                    .bold()
                }
                .padding()
            }
        }
    }
    
    private func sortPeriods(by option: SortOption) {
        // sorting logic
        if let periods = weatherViewModel.extendedForecast?.properties.periods {
            switch option {
            case .mostRecent:
                sortedPeriods = periods.sorted(by: { $0.startTime < $1.startTime })
            case .leastRecent:
                sortedPeriods = periods.sorted(by: { $0.startTime > $1.startTime })
            case .highestTemp:
                sortedPeriods = periods.sorted(by: { $0.temperature > $1.temperature })
            case .lowestTemp:
                sortedPeriods = periods.sorted(by: { $0.temperature < $1.temperature })
            }
        }
    }
}


#Preview {
    WeatherView()
}
