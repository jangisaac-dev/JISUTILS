//
//  DefAlertUtils.swift
//  jutils
//
//  Created by Isaac Jang on 2021/02/01.
//

import Foundation
import UIKit

class DefAlertUtils {
    public static func showAlert(viewController: UIViewController?,title: String, msg: String, buttonTitle: String, handler: ((UIAlertAction) -> Swift.Void)?){
            
          let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            
          let defaultAction = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
          alertController.addAction(defaultAction)
        
          viewController?.present(alertController, animated: true, completion: nil)
    }
    
    public static func showAlertTwoBtn(viewController: UIViewController?,title: String, msg: String, positive: ((UIAlertAction) -> Swift.Void)?, negative: ((UIAlertAction) -> Swift.Void)?){
            
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            
        let defaultAction = UIAlertAction(title: "확인", style: .default, handler: positive)
        alertController.addAction(defaultAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: negative)
        alertController.addAction(cancelAction)
        
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    public static func getTransitionModal() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = "push"
        transition.subtype = "fromRight"
        transition.timingFunction = CAMediaTimingFunction(name:"easeInEaseOut")
        return transition
    }
}
