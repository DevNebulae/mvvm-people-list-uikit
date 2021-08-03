//
//  PersonResponse.swift
//  MVVM People List
//
//  Created by Ivo Huntjens on 03/08/2021.
//

import Foundation

struct PersonResponse : Decodable {
    let page: Int
    let perPage: Int
    let total: Int
    let totalPages: Int
    let data: [Person]
}
