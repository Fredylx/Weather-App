//
//  EndPoint.swift
//  Weather
//
//  Created by Fredy Lopez on 28/08/23.
//

import Foundation

enum ServiceEndPoints {
    static let baseUrl = "https://api.openweathermap.org/data/2.5"
    static let appId = "fad7be6d3efab6853151833dfe5b49c2"
}

enum APIPath:String {
    case weather = "/weather"
    case onecall = "/onecall"
}
