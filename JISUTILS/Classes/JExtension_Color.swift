//
//  JExtension_Color.swift
//  jutils
//
//  Created by Isaac Jang on 2021/02/01.
//

import Foundation
import UIKit


public extension UIColor {
    
    static func rgbToUIColor(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return String(format:"#%06x", rgb)
    }
    
    var toRGBA: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            return (
                red: fRed * 255.0,
                green: fGreen * 255.0,
                blue: fBlue * 255.0,
                alpha: fAlpha * 255.0
            )
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    
    func colorConvert(to color: UIColor, multiplier _multiplier: CGFloat) -> UIColor? {
        let multiplier = min(max(_multiplier, 0), 1)

        let components = cgColor.components ?? []
        let toComponents = color.cgColor.components ?? []

        if components.isEmpty || components.count < 3 || toComponents.isEmpty || toComponents.count < 3 {
            return nil
        }

        var results: [CGFloat] = []

        for index in 0...3 {
            let result = (toComponents[index] - components[index]) * abs(multiplier) + components[index]
            results.append(result)
        }

        return UIColor(red: results[0], green: results[1], blue: results[2], alpha: results[3])
    }
}
