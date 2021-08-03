//
//  Person.swift
//  MVVM People List
//
//  Created by Ivo Huntjens on 03/08/2021.
//

import Foundation

struct Person : Decodable {
    let firstName: String
    let lastName: String
    let email: String
    lazy var fullName: String = "\(firstName) \(lastName)"
    let avatar: String
}
