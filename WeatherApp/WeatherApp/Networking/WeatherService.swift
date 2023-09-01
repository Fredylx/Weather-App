//
//  NetworkManager.swift
//  Weather
//
//  Created by Fredy Lopez 28/08/23.
//


import Foundation
import Combine

protocol WeatherService {
    func get(urlRequest:URLRequest)-> AnyPublisher<Data, ServiceError>
}

 
