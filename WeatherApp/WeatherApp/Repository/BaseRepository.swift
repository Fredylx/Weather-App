//
//  BaseRepository.swift
//  Weather
//
//  Created by Fredy Lopez on 28/08/23.
//

import Foundation

class BaseRepository {
    var weatherService:WeatherService

    init(weatherService:WeatherService = WeatherServiceImpl()) {
        self.weatherService = weatherService
    }
}

