//
//  JExtension_Net.swift
//  jutils
//
//  Created by Isaac Jang on 2021/02/01.
//

import Foundation

extension URLComponents {
    
    public func asURL() throws -> URL {
        guard let url = url else { throw JNet.JNetError.urlConvFailed }

        return url
    }
}

