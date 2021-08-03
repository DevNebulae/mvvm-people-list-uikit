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
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [unowned self] response in
                    self.people.send(response.data)
                    self.isDoneLoading = response.page == page
            })
            .store(in: &subscriptions)
    }
}
