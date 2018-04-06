//
//  MapViewModel.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 13/02/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import Foundation

extension Date {
    func isBetween(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self) == self.compare(date2)
    }
}


class MapViewModel{
    var activeStatus: Bool?
    
    func checkIfActive(start: String, end: String) -> Bool
    {
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM dd,yyyy hh:mma"

        dateFormatterPrint.locale = Locale(identifier: "en_GB")
        
        let dateStart = dateFormatterPrint.date(from: start)
        let dateEnd = dateFormatterPrint.date(from: end)
        
        
    
            
            if(Date().isBetween(date: dateStart!, andDate: dateEnd!))
            {
                return true
            }
        
        return false
    }
    
}
