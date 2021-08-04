//
//  PeopleAPI.swift
//  MVVM People List
//
//  Created by Ivo Huntjens on 03/08/2021.
//

import Combine
import Foundation

class PeopleAPI {
    let pageSize = 10
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    /**
    Fetch the user's avatar from the API.
     */
    func fetchAvatar(url: URL) -> AnyPublisher<Data, Error> {
        return session.dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let response = element.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                return element.data
            }
            .eraseToAnyPublisher()
    }
    
    /**
     Fetch people from the API.
     */
    func fetchPeople(_ page: Int) -> AnyPublisher<PersonResponse, Error> {
        let queryItems = [URLQueryItem(name: "per_page", value: "\(pageSize)"), URLQueryItem(name: "page", value: "\(page)")]
        var urlComponents = getURLComponents()
        urlComponents.queryItems = queryItems
        let url = urlComponents.url!
        
        return session.dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let response = element.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                return element.data
            }
            .decode(type: PersonResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func getURLComponents() -> URLComponents {
        return URLComponents(string: "https://reqres.in/api/users")!
    }
}
