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
    
    /**
    Fetch the user's avatar from the API.
     */
    func fetchAvatar(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
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
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let response = element.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                if response.statusCode == 200 {
                    return element.data
                } else if let cachedResponse = URLSession.shared.configuration.urlCache?.cachedResponse(for: URLRequest(url: url)) {
                    return cachedResponse.data
                } else {
                    throw URLError(.badServerResponse)
                }
            }
            .decode(type: PersonResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func getURLComponents() -> URLComponents {
        return URLComponents(string: "https://reqres.in/api/users")!
    }
}
