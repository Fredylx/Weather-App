//
//  ContentView.swift
//  WeatherApp
//
//  Created by Fredy Lopez on 30/08/23.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel = WeatherDetailsViewModel()
    var cityName: String = "Fontana" // Placeholder city name
    var temperature: String = "66" // Placeholder temperature
    var weatherConditions: String = "Mostly Sunny" // Placeholder weather conditions
    var highTemperature: String = "78" // Placeholder high temperature
    var lowTemperature: String = "60" // Placeholder low temperature

    var hourlyTemperatures: [Int] = [72, 71, 70, 69, 68, 67, 66, 65, 64, 63, 62, 61, 60, 59, 58] // Placeholder hourly temperatures
    let currentHour = Calendar.current.component(.hour, from: Date())

    var tenDayForecast: [ForecastDay] = [
        ForecastDay(date: "Mon", temperatureHigh: "82", temperatureLow: "65", weatherIcon: "sun.max.fill"),
        ForecastDay(date: "Tue", temperatureHigh: "79", temperatureLow: "62", weatherIcon: "cloud.sun.fill"),
        ForecastDay(date: "Wed", temperatureHigh: "76", temperatureLow: "58", weatherIcon: "cloud.fill"),
        // Add more forecast days...
    ]
    
    // Function to determine the appropriate icon based on temperature
    func icon(for temperature: Int) -> String {
        if temperature > 70 {
            return "sun.max.fill"
        } else if temperature < 60 {
            return "cloud.rain.fill"
        } else {
            return "cloud.sun.fill"
        }
    }
    
    var body: some View {
        ZStack {
            Color("LightBlueBackground") // Light blue background
                .edgesIgnoringSafeArea(.all) // Extend background to top and bottom

            
            VStack {
                // City name in white text
                Text(cityName)
                    .font(.title)
                    .foregroundColor(.white)
                
                // Temperature display
                Text("\(temperature)°")
                    .font(.system(size: 40)) // Bigger font size
                    .foregroundColor(.white)
                
                // Weather conditions display
                Text(weatherConditions)
                    .font(.headline) // Use a smaller font size
                    .foregroundColor(.white)
                
                // Highs and Lows temperature display
                HStack {
                    Text("H: \(highTemperature)°")
                        .foregroundColor(.white)
                    Text("L: \(lowTemperature)°")
                        .foregroundColor(.white)
                }
            
                // Hourly temperature list
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(hourlyTemperatures.indices, id: \.self) { index in
                            VStack {
                                Image(systemName: icon(for: hourlyTemperatures[index]))
                                    .foregroundColor(.white)
                                    .font(.system(size: 25))
                                Text("\(hourlyTemperatures[index])°")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                            }
                            .padding(8)
                            .background(Color("TransparentGray"))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                // 10-day forecast section
                 VStack {
                     Text("10-Day Forecast")
                         .font(.headline)
                         .foregroundColor(.white)
                         .padding(.top, 20)
                     
                     ScrollView(.horizontal) {
                         HStack(spacing: 12) {
                             ForEach(tenDayForecast, id: \.date) { day in
                                 VStack {
                                     Image(systemName: day.weatherIcon)
                                         .renderingMode(.original)
                                         .font(.system(size: 30))
                                     Text(day.date)
                                         .foregroundColor(.white)
                                         .font(.subheadline)
                                     Text("H: \(day.temperatureHigh)° L: \(day.temperatureLow)°")
                                         .foregroundColor(.white)
                                         .font(.subheadline)
                                 }
                                 .padding(8)
                                 .background(Color("TransparentGray"))
                                 .cornerRadius(8)
                             }
                         }
                         .padding(.horizontal, 20)
                     }
                 }
                
                // Current weather display
                Text("Current Weather")
                // ... Other weather details ...
                
                // Daily forecast section
                List {
                    // ... Forecast cells ...
                }
            }
        }
        .onAppear {
            viewModel.getWeather("Fontana")
        }
    }
    
    // Function to determine the appropriate background image
    func backgroundImage(for condition: String) -> some View {
        let imageName: String
        
        switch condition {
            case "Clear": imageName = "sunny_background"
            case "Rain": imageName = "rainy_background"
            case "Cloudy": imageName = "cloudy_background"
            // Add more cases for other conditions
            default: imageName = "default_background"
        }
        
        return Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ForecastDay: Identifiable {
    let id = UUID()
    var date: String
    var temperatureHigh: String
    var temperatureLow: String
    var weatherIcon: String
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}

