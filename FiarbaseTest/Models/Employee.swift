//
//  Employee.swift
//  FiarbaseTest
//
//  Created by Vladimir Budniy on 1/31/17.
//  Copyright © 2017 Vladimir Budniy. All rights reserved.
//

import Foundation
import Firebase

struct Employee {
    
    var name: String?
    var birthday: Double?
    var photo: String?
    var developer: Bool?
    var ref: FIRDatabaseReference
    
    static func createFrom(snapshot: FIRDataSnapshot) -> Employee {
        let value = snapshot.value as? NSDictionary
        let name = value?["name"] as? String
        let birthday = value?["birthday"] as? Double
        let photo = value?["photo"] as? String
        let developer = value?["developer"] as? Bool
        let ref = snapshot.ref
        
        return Employee(name: name, birthday: birthday, photo: photo, developer: developer, ref: ref)
    }
    
}
