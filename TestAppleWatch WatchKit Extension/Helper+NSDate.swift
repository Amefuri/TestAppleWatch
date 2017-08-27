//
//  Helper+NSDate.swift
//  fleet
//
//  Created by peerapat atawatana on 7/15/2559 BE.
//  Copyright © 2559 Socket9. All rights reserved.
//

import Foundation

class Helper {
    
        
        static func stringFromDate(date:Date, format:String) -> String {
            return stringFromDate(date: date, format:format, calendarIdentifier:Calendar.Identifier.gregorian)
        }
        
        // Wrapper for NSDateFormatter stringFromDate() - one time action shouldn't use in array
        static func stringFromDate(date:Date, format:String, calendarIdentifier:Calendar.Identifier) -> String {
            let dateFormatter           = DateFormatter()
            dateFormatter.dateFormat    = format
            dateFormatter.calendar      = Calendar(identifier: calendarIdentifier)
            return dateFormatter.string(from: date)
        }
        
        static func dateFromString(string:String, format:String) -> Date? {
            return dateFromString(string: string, format: format, calendarIdentifier: Calendar.Identifier.gregorian)
        }
        
        // Wrapper for NSDateFormatter dateFromString() - one time action shouldn't use in array
        static func dateFromString(string:String, format:String, calendarIdentifier:Calendar.Identifier) -> Date? {
            let dateFormatter           = DateFormatter()
            dateFormatter.dateFormat    = format
            dateFormatter.calendar      = Calendar(identifier: calendarIdentifier)
            return dateFormatter.date(from: string)
        }
    
}
