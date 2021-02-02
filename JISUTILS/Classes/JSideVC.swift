//
//  JSideVC.swift
//  jutils
//
//  Created by Isaac Jang on 2021/02/01.
//

import Foundation
import UIKit

import UIKit

public class JSideVC: JVC {
    
    var menuPadding : CGFloat = 90
    var backgroundView = UIView()
    var mainFrame = UIView()
    var isLeftMenu = true
    
    private var horizontalConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDefaultViews()
        
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickBackground)))
    }
    
    @objc func onClickBackground() {
        hideAnimation { (result) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func initDefaultViews() {
        view.backgroundColor = .clear
        view.alpha = 1.0
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.3
        view.addSubview(backgroundView)
        
        mainFrame.translatesAutoresizingMaskIntoConstraints = false
        mainFrame.backgroundColor = .white
        mainFrame.alpha = 1.0
        
        view.addSubview(mainFrame)
        
        if isLeftMenu {
            horizontalConstraint = mainFrame.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: (screenWidth * -1))
        }
        else {
            horizontalConstraint = mainFrame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: (screenWidth))
        }
        
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainFrame.topAnchor.constraint(equalTo: view.topAnchor),
            mainFrame.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainFrame.widthAnchor.constraint(equalToConstant: screenWidth - menuPadding),
            horizontalConstraint
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        showAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func hideAnimation(completion: ((Bool) -> Void)?) {
        if isLeftMenu {
            horizontalConstraint.constant = (screenWidth * -1)
        }
        else {
            horizontalConstraint.constant = screenWidth
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }, completion: completion)
        
    }
    
    func showAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.isLeftMenu {
                self.horizontalConstraint.constant = (self.menuPadding * -1)
            }
            else {
                self.horizontalConstraint.constant = (self.menuPadding)
            }
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
}

