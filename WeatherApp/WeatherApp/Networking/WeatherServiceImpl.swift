//
//  WeatherServiceImpl.swift
//  Weather
//
//  Created by 28/08/23.
//

import Foundation
import Combine

class WeatherServiceImpl: WeatherService {
    
    func get(urlRequest:URLRequest)-> AnyPublisher<Data, ServiceError> {
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .tryMap { response -> Data in
                guard
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    throw ServiceError.errorWith(message:"Failed to fetch data")
                }
                
                return response.data
            }
            .mapError { ServiceError.map($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
