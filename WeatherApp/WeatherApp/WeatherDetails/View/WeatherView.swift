//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Fredy Lopez on 30/08/23.
//

import SwiftUI

struct WeatherView: View {
    
    @ObservedObject var viewModel = WeatherDetailsViewModel()
    
    let currentHour = Calendar.current.component(.hour, from: Date())
    
    struct HourlyWeather {
        var temperature: Int
        var time: String
    }
    var hourlyTemperatures: [HourlyWeather] = [
        HourlyWeather(temperature: 72, time: "10:00 AM"),
        HourlyWeather(temperature: 71, time: "11:00 AM"),
        HourlyWeather(temperature: 70, time: "12:00 PM"),
        HourlyWeather(temperature: 69, time: "1:00 PM"),
        HourlyWeather(temperature: 72, time: "12:00 PM"),
        HourlyWeather(temperature: 71, time: "1:00 PM"),
        HourlyWeather(temperature: 70, time: "2:00 PM"),
        HourlyWeather(temperature: 69, time: "3:00 PM"),
    ]
    var cityName: String = "Fontana" // Placeholder city name
    var tenDayForecast: [ForecastDay] = [
        ForecastDay(date: "Mon", temperatureHigh: "82", temperatureLow: "65", weatherIcon: "sun.max.fill"),
        ForecastDay(date: "Tue", temperatureHigh: "79", temperatureLow: "62", weatherIcon: "cloud.sun.fill"),
        ForecastDay(date: "Wed", temperatureHigh: "76", temperatureLow: "58", weatherIcon: "cloud.fill"),
        ForecastDay(date: "Thu", temperatureHigh: "75", temperatureLow: "59", weatherIcon: "cloud.fill"),
        ForecastDay(date: "Fri", temperatureHigh: "78", temperatureLow: "61", weatherIcon: "cloud.sun.fill"),
        ForecastDay(date: "Sat", temperatureHigh: "80", temperatureLow: "63", weatherIcon: "sun.max.fill"),
        ForecastDay(date: "Sun", temperatureHigh: "83", temperatureLow: "66", weatherIcon: "sun.max.fill"),
        ForecastDay(date: "Mon", temperatureHigh: "82", temperatureLow: "65", weatherIcon: "sun.max.fill"),
        ForecastDay(date: "Tue", temperatureHigh: "79", temperatureLow: "62", weatherIcon: "cloud.sun.fill"),
        ForecastDay(date: "Wed", temperatureHigh: "76", temperatureLow: "58", weatherIcon: "cloud.fill")
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
        VStack {
            switch viewModel.viewState {
            case .loaded :
                ZStack {
                    Color("LightBlueBackground") // Light blue background
                        .edgesIgnoringSafeArea(.all) // Extend background to top and bottom
                    VStack {
                        // City name in white text
                        Text("Today's Forecast")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.top, 20)
                        if viewModel.viewState == .loading {
                                        Text("Loading...")
                                            .foregroundColor(.white)
                                    } else if viewModel.viewState == .error {
                                        Text("Error loading data.")
                                            .foregroundColor(.red)
                                    } else {
                                        Picker("Forecast Type", selection: $viewModel.weatherForcastType) {
                                            ForEach(viewModel.filterOptions, id: \.self) { option in
                                                Text(option.rawValue)
                                                    .tag(option)
                                            }
                                        }
                                        .pickerStyle(SegmentedPickerStyle())
                                        .padding()
                                    }
                        if let weatherDetails = viewModel.getCurrentWeatherDetails() {
                            
                            Text(weatherDetails.cityName)
                                .font(.title)
                                .foregroundColor(.white)
                            Text(cityName)
                                .font(.title)
                                .foregroundColor(.white)
                            
                            // Temperature display
                            Text("\(Int(weatherDetails.temprature))°")
                                .font(.system(size: 40)) // Bigger font size
                                .foregroundColor(.white)
                            
                            // Weather conditions display
                            Text("Humidity: \(weatherDetails.humadity)")
                                .font(.headline) // Use a smaller font size
                                .foregroundColor(.white)
                            
                            // Highs and Lows temperature display
                            HStack {
                                Text("H: \(weatherDetails.humadity)")
                                    .foregroundColor(.white)
                                Text("L: \(weatherDetails.humadity)")
                                    .foregroundColor(.white)
                            }
                            // Additional information section
                            VStack {
                                Text("Additional Information")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.top, 20)

                                // Customize the additional information here
                                Text("Wind Speed: 10 mph")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .padding(.bottom, 4)

                                Text("UV Index: 6")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .padding(.bottom, 4)

                                Text("Sunrise: 6:30 AM")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .padding(.bottom, 4)

                                Text("Sunset: 7:45 PM")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                            }
                            
                            

                            // Additional information section
                            VStack {
                                Text("Additional Information")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.top, 20)

                                // Wind Speed
                                if let windSpeed = viewModel.weatherForcast?.current?.windSpeed {
                                    Text("Wind Speed: \(windSpeed) mph")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                        .padding(.bottom, 4)
                                }

                                // UV Index
                                if let uvi = viewModel.weatherForcast?.current?.uvi {
                                    Text("UV Index: \(uvi)")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                        .padding(.bottom, 4)
                                }

                            }
                            
                                // Hourly temperature list
                                ScrollView(.horizontal) {
                                    HStack(spacing: 12) {
                                        ForEach(hourlyTemperatures.indices, id: \.self) { index in
                                            VStack {
                                                Image(systemName: icon(for: hourlyTemperatures[index].temperature))
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 25))
                                                Text("\(hourlyTemperatures[index].temperature)°")
                                                    .foregroundColor(.white)
                                                    .font(.subheadline)
                                            }
                                            .padding(8)
                                            .background(Color(white: 0.65))
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
                        }
                    }
                }
            case .loading:
                Text("Loading")
            case .error:
                Text("Something went wrong pls try again")
            }
        }
            .onAppear {
                viewModel.getWeather("Fontana")
            }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: WeatherDetailsViewModel())
    }
}
