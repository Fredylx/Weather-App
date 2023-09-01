//
//  WeatherRepository.swift
//  Weather
//
//  Created by Fredy Lopez on 28/08/23.
//

import Foundation
import Combine

class WeatherRepositoryImpl:BaseRepository, WeatherRepository {
    
    func searchWeatherForcast<T>(lat: String, lon: String, exclude: String, modelType: T.Type) -> AnyPublisher<T, ServiceError> where T : Decodable {
        
        guard let urlRequest = URLRequest.getRequest(baseUrl: ServiceEndPoints.baseUrl, path: APIPath.onecall.rawValue, params: ["lat":lat, "lon":lon,"exclude":exclude, "appid":ServiceEndPoints.appId], requestType: RequestType.get) else {
            
            return Fail(error: .requestNotCreated(message:"Request is not created"))
                .eraseToAnyPublisher()
        }
        
        return weatherService.get(urlRequest: urlRequest)
            .decode(type: T.self, decoder: JSONDecoder())
            .tryMap { result in
                return result
            }
            .mapError { ServiceError.map($0) }
            .eraseToAnyPublisher()
    }
    
    func search<T>(location: String, modelType: T.Type) -> AnyPublisher<T, ServiceError> where T : Decodable {
        guard let urlRequest = URLRequest.getRequest(baseUrl: ServiceEndPoints.baseUrl, path: APIPath.weather.rawValue, params: ["q":location, "appid":ServiceEndPoints.appId], requestType: RequestType.get) else {
            
            return Fail(error: .requestNotCreated(message:"Request is not created"))
                .eraseToAnyPublisher()
        }
        
        return weatherService.get(urlRequest: urlRequest)
            .decode(type: T.self, decoder: JSONDecoder())
            .tryMap { result in
                return result
            }
            .mapError { ServiceError.map($0) }
            .eraseToAnyPublisher()
    }
}
