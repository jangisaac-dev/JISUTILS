//
//  JExtension_UIView.swift
//  jutils
//
//  Created by Isaac Jang on 2021/02/01.
//

import Foundation

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            if !halfRound {
                layer.cornerRadius = newValue
                layer.masksToBounds = newValue > 0
            }
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var halfRound: Bool {
        set {
            if (!newValue) {
                return
            }
            layer.cornerRadius = layer.frame.height / 2
        }
        get {
            return false
        }
    }
    
    @IBInspectable var setShadow: Bool {
        set {
            if (!newValue) {
                return
            }
            self.layer.shadowOpacity = 0.15
            self.layer.shadowRadius = 6.33
            self.layer.shadowColor = UIColor.rgbToUIColor(r: 130, g: 130, b: 130).cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.masksToBounds = false
        }
        get {
            return false
        }
    }
}




extension CALayer {
  func applySketchShadow(
    color: UIColor = .black,
    alpha: Float = 0.5,
    x: CGFloat = 0,
    y: CGFloat = 2,
    blur: CGFloat = 4,
    spread: CGFloat = 0)
  {
    masksToBounds = false
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2.0
    if spread == 0 {
      shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}
