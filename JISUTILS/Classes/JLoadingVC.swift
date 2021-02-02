//
//  JLoadingVC.swift
//  jutils
//
//  Created by Isaac Jang on 2021/02/01.
//

import UIKit

public class JLoadingVC: UIViewController {
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func initialize() {
        view.backgroundColor = .black
        view.alpha = 0.5

        let indicator = UIActivityIndicatorView()



        view.addSubview(indicator)

        NSLayoutConstraint.activate([
            indicator.widthAnchor.constraint(equalToConstant: 100),
            indicator.heightAnchor.constraint(equalToConstant: 100),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        indicator.startAnimating()
    }
    
    
}

