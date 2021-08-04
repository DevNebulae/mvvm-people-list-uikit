//
//  Person.swift
//  MVVM People List
//
//  Created by Ivo Huntjens on 03/08/2021.
//

import Foundation

struct Person : Decodable {
    let id: Int64
    let firstName: String
    let lastName: String
    let email: String
    lazy var fullName: String = "\(firstName) \(lastName)"
    let avatar: String?
    
    init(id: Int64, firstName: String, lastName: String, email: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.avatar = nil
    }
}
