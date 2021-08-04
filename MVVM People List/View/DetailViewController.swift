//
//  DetailViewController.swift
//  MVVM People List
//
//  Created by Ivo Huntjens on 03/08/2021.
//

import UIKit

class DetailViewController: UIViewController {
    var person: Person!
    
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailAddressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = person.fullName
        
        avatarImageView.circle()
        nameLabel.text = person.fullName
        emailAddressLabel.text = person.email
        if let avatar = person.avatar, let url = URL(string: avatar) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }

                DispatchQueue.main.async { [unowned self] in
                    self.avatarImageView.image = UIImage(data: data)
                }
            }

            task.resume()
        }
    }
}
