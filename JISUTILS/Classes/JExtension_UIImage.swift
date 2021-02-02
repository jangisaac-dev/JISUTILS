//
//  JExtension_UIImage.swift
//  jutils
//
//  Created by Isaac Jang on 2021/02/01.
//

import Foundation
import UIKit

extension UIImage {
    
    var getData : Data? {
        return UIImageJPEGRepresentation(self, 1)
    }
    
    func compressToMb(_ expectedSizeInMb:CGFloat) -> UIImage? {
        let sizeInBytes = expectedSizeInMb * 1000 * 1000
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = UIImageJPEGRepresentation(self, compressingValue) {
            if CGFloat(data.count) < sizeInBytes {
                needCompress = false
                imgData = data
            } else {
                compressingValue -= 0.2
            }
        }
    }
        
    if let data = imgData {
        if (CGFloat(data.count) < sizeInBytes) {
            return UIImage(data: data)
        }
    }
        return nil
    }
    
    func compressToKb(_ expectedSizeInKb:CGFloat) -> UIImage? {
        let sizeInBytes = expectedSizeInKb * 1000
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 0.5
        var lastData: Data?
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = UIImageJPEGRepresentation(self, compressingValue) {
                if lastData != nil {
                    if lastData!.count == data.count {
                        break
                    }
                }
                lastData = data
                if CGFloat(data.count) < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.2
                }
            }
        }

        if let data = imgData {
            if (CGFloat(data.count) < sizeInBytes) {
                return UIImage(data: data)
            }
        }
        if lastData != nil{
            guard let img = UIImage(data: lastData!)?.resized(toWidth: self.size.width / 2) else {
                return nil
            }
            return img.compressToKb(50)
        }
        return nil
    }
    
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
