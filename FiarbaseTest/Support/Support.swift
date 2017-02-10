//
//  Support.swift
//  FiarbaseTest
//
//  Created by Vladimir Budniy on 1/30/17.
//  Copyright © 2017 Vladimir Budniy. All rights reserved.
//

import Foundation

func formateDate(date: Date?) -> String? {
    var dateString: String?
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.medium
    if let date = date {
        dateString = dateFormatter.string(from: date)
    }
    
    return dateString
}
