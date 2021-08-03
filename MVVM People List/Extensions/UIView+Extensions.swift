//
//  UIView+Extensions.swift
//  MVVM People List
//
//  Created by Ivo Huntjens on 03/08/2021.
//

import UIKit

extension UIView {
    func circle() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
