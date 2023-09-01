//
//  WeatherRepository.swift
//  Weather
//
//  Created by Fredy Lopez on 28/08/23.
//

import Foundation
import Combine

protocol WeatherRepository {
    func search<T:Decodable>(location:String, modelType:T.Type)-> AnyPublisher<T, ServiceError>
    func searchWeatherForcast<T:Decodable>(lat:String, lon:String, exclude:String,  modelType:T.Type)-> AnyPublisher<T, ServiceError>
}


