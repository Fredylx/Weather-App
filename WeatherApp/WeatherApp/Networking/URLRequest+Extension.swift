//
//  URLRequest+Extension.swift
//  Weather
//
//  Created by 28/08/23.
//

import Foundation

enum RequestType:String {
    case get = "GET"
    case post = "POST"
}

extension URLRequest {
    static func getRequest(baseUrl:String, path:String,  params:[String:String], requestType:RequestType)-> Self? {
        guard var urlComponents = URLComponents(string:baseUrl.appending(path)) else {
            return nil
        }
        if requestType == .get {
            var queryItems:[URLQueryItem] = []
            for (key , value) in params {
                queryItems.append( URLQueryItem(name: key, value: value))
            }
            urlComponents.queryItems = queryItems
        }
        
        guard let url = urlComponents.url else {
            return nil
        }
        var request = URLRequest(url: url)
        
        switch requestType {
        case .get:
            request.httpMethod = RequestType.get.rawValue
        case .post:
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
                request.httpMethod = RequestType.post.rawValue

            }catch {
                return nil
            }
        }
        return request
    }
}
