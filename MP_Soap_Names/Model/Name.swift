//
//  names.swift
//  MP_Soap_Names
//
//  Created by Hari Dass Khalsa on 5/4/26.
//

import Foundation
import SwiftData

@Model
final class Name {
    var dbid: String
    var lastname: String
    var firstname: String
    var fullname: String {
        return "\(firstname) \(lastname)"
    }
    var gender: String
    var dob: Date?
     var startDate: Date?
    var endDate: Date?
    var count: Int
    var dbSource: String

    init(dbid: String, lastname: String, firstname: String, gender: String, dob: Date? = nil, startDate: Date? = nil, endDate: Date? = nil, count: Int, dbSource: String) {
        self.dbid = dbid
        self.lastname = lastname
        self.firstname = firstname
        self.startDate = startDate
        self.endDate = endDate
        self.count = count
        self.dbSource = dbSource
        self.gender = gender
        self.dob = dob
    }
}
