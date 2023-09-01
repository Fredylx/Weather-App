//
//  Date+Extension.swift
//  Weather
//
//  Created by Fredy Lopez on 28/08/23.
//

import Foundation

extension Date {
   
    static func getDate(milliSec:Int, format:String)-> String {
        let date = Date(timeIntervalSince1970: (Double(milliSec) ))
        return date.getDateString(for: format)
    }
    
    static func getHr(milliSec:Int, format:String)-> String {
        let date = Date(timeIntervalSince1970: (Double(milliSec) ))
        return date.getDateString(for: format)
    }
    
    func getDateString(for format:String)-> String {

        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = format //"EEEE-MM/dd/YYYY"

        // Convert Date to String
      return dateFormatter.string(from: self)
    }
}
