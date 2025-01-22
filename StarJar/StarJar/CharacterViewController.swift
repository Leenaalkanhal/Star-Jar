//
//  CharacterViewController.swift
//  StarJar
//
//  Created by Leena  on 21/07/1446 AH.
//

import UIKit

class CharacterViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Tracker"

        let label = UILabel()
        label.text = "Tracker Screen"
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
