//
//  MainViewController.swift
//  MVVM People List
//
//  Created by Ivo Huntjens on 03/08/2021.
//

import Combine
import Foundation
import UIKit

class MainViewController : UITableViewController {
    private var isLoading = false
    private var subscriptions = Set<AnyCancellable>()
    private let viewModel = PersonListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "People"
        
        viewModel.people
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                self.tableView.reloadData()
                self.isLoading = false
            }
            .store(in: &subscriptions)
        
        fetchData()
    }
    
    private func fetchData() {
        viewModel.getPeople()
        isLoading = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController, let person = sender as? Person {
            destination.person = person
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height * 4 && !isLoading && !viewModel.isDoneLoading {
            fetchData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.people.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonCell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? PersonCell else { return }
        var person = viewModel.people.value[indexPath.row]
        
        cell.nameLabel.text = person.fullName
        if let url = URL(string: person.avatar) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }

                DispatchQueue.main.async {
                    cell.avatarImageView.image = UIImage(data: data)
                }
            }

            task.resume()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Detail", sender: viewModel.people.value[indexPath.row])
    }
}
