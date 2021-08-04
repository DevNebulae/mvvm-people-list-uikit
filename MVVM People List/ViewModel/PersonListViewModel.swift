//
//  PersonListViewModel.swift
//  MVVM People List
//
//  Created by Ivo Huntjens on 03/08/2021.
//

import Combine
import Foundation

class PersonListViewModel {
    var isDoneLoading = false
    var people = CurrentValueSubject<[Person], Never>([Person]())
    private let api = PeopleAPI()
    private let context = AppDelegate.instance.persistentContainer.viewContext
    private var subscriptions = Set<AnyCancellable>()
    
    /**
     * Fetches and automatically processes the paginated results in a single list. Subscribe on the `people` property to receive the complete list.
     */
    func getPeople() {
        /**
         * Examples:
         *  0 / 10 = 0; 0 + 1 = 1
         *  10 / 10 = 1; 1 + 1 = 2
         */
        let page = people.value.count / api.pageSize + 1
        api.fetchPeople(page)
            .last()
            .tryCatch { _ in
                Future<PersonResponse, Error> { [unowned self] promise in
                    let items = try! self.context.fetch(PersonEntity.fetchRequest()) as! [PersonEntity]
                    let lowerBound = api.pageSize * (page - 1)
                    let upperBound = min(api.pageSize * page, items.count)
                    let paged = items.isEmpty ? [] : items[lowerBound..<upperBound]
                        .map {
                            return Person(id: $0.id, firstName: $0.firstName!, lastName: $0.lastName!, email: $0.email!)
                        }
                    let response = PersonResponse(
                        page: page,
                        perPage: api.pageSize,
                        total: items.count,
                        totalPages: Int(ceil(Double(items.count) / Double(api.pageSize))),
                        data: paged
                    )
                    promise(.success(response))
                }.eraseToAnyPublisher()
            }
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [unowned self] response in
                    self.people.send([self.people.value, response.data].flatMap { $0 })
                    self.isDoneLoading = response.page == response.totalPages
                    
                    response.data.forEach { person in
                        let item = PersonEntity.init(context: self.context)
                        item.email = person.email
                        item.firstName = person.firstName
                        item.id = person.id
                        item.lastName = person.lastName
                        
                        context.insert(item)
                    }
                    
                    AppDelegate.instance.saveContext()
            })
            .store(in: &subscriptions)
    }
}
