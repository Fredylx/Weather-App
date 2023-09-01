//
//  ServiceError.swift
//  Weather
//
//  Created by Fredy Lopez 28/08/23.
//

import Foundation


enum ServiceError: Error {
    case requestNotCreated(message:String)
    case parsinFailed(message:String)
    case errorWith(message:String)
    case networkNotAvailalbe
    case malformedURL(message:String)
    case other(Error)

    static func map(_ error: Error) -> ServiceError {
       return (error as? ServiceError) ?? .other(error)
     }
}
