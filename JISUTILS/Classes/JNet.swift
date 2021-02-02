//
//  JNet.swift
//  jutils
//
//  Created by Isaac Jang on 2021/02/01.
//

import Foundation
import UIKit
import SystemConfiguration

public class JNet {
    private var jnet : JNet?
    public func shared() throws -> JNet {
        if jnet == nil {
            throw JNetError.initialFailed
        }
        else {
            return jnet!
        }
    }
    
    private var urlComponents = URLComponents()
    public init(scheme: String, url: String, port: Int) {
        urlComponents.scheme = scheme
        urlComponents.host = url
        urlComponents.port = port
        jnet = self
    }
    
    public enum JNetError : Error {
        case urlConvFailed
        case initialFailed
    }
    
    public enum HTTPMethod : String {
        case CONNECT
        case DELETE
        case GET
        case HEAD
        case OPTIONS
        case PATCH
        case POST
        case PUT
        case TRACE
    }
    
    public func getUrlcomponents() -> URLComponents {
        return urlComponents
    }
    
    //callback
    private var successClosure:((Data)->Void)? // success
    private var localFailClosure:((String)->Void)? // local error
    
    //settingValues
    private var requestMethod : HTTPMethod?
    private var params : String?
    
    @discardableResult
    public func setCallback(_ sc: ((Data)->Void)? = nil, _ lfc: ((String)->Void)? = nil) -> Self {
        self.successClosure = sc
        self.localFailClosure = lfc
        return self
    }

    @discardableResult
    private func setPath (_ pt : String) -> Self{
        _ = try? urlComponents.asURL()
        self.urlComponents.path = pt
        return self
    }
    
    @discardableResult
    private func setQuery (_ qr : String?) -> Self{
        guard let qr = qr else {
            return self
        }
        _ = try? urlComponents.asURL()
        self.urlComponents.query = qr
        return self
    }
    @discardableResult
    private func setQueryList (_ qi : [URLQueryItem]) -> Self{
        _ = try? urlComponents.asURL()
        self.urlComponents.queryItems = qi
        return self
    }
    
    @discardableResult
    private func setMethod (_ method: HTTPMethod) -> Self {
        self.requestMethod = method
        return self
    }
    
    @discardableResult
    private func setParams(_ value: String?) -> Self {
        self.params = value
        return self
    }
    
    @discardableResult
    private func setParams(_ value: [String: Any]?) -> Self {
        guard let value = value else { return self }
        if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []) {
            let jsonDataString = String(data: jsonData, encoding: String.Encoding.utf8)!
            return self.setParams(jsonDataString)
        }
        return self
    }
    
    public func getQueryItem(query: [String:Any]) -> [URLQueryItem] {
        var querys = [URLQueryItem]()
        for item in query {
            querys.append(URLQueryItem(name: item.key, value: "\(item.value)"))
        }
        return querys
    }
    
    //action Methods
    public func request(path: String, method: HTTPMethod, query: [String:Any]?) {
        if let q = query {
            var querys = [URLQueryItem]()
            for item in q {
                querys.append(URLQueryItem(name: item.key, value: "\(item.value)"))
            }
            self.setQueryList(querys)
        }
        
        self.setPath(path)
        self.setMethod(method)
        self.request()
    }
    
    public func request(path: String, method: HTTPMethod, parameters: String?) {
        self.setPath(path)
        self.setMethod(method)
        self.setParams(parameters)
        
        self.request()
    }
    
    public func request(path: String, method: HTTPMethod, parameters: [String:Any]) {
        self.setPath(path)
        self.setMethod(method)
        self.setParams(parameters)
        
        self.request()
    }
    
    public func request(path: String, method: HTTPMethod, query: [String:Any]?, parameters: [String:Any]?) {
        if let q = query {
            var querys = [URLQueryItem]()
            for item in q {
                querys.append(URLQueryItem(name: item.key, value: "\(item.value)"))
            }
            self.setQueryList(querys)
        }
        
        if let params = parameters {
            self.setParams(params)
        }
        
        self.setPath(path)
        self.setMethod(method)
        self.request()
    }
    
    //body Method
    public func request() {
        guard let requestUrl = try? urlComponents.asURL() else {
            callLocalFail("requestUrl Error")
            return
        }

        guard let method = requestMethod else {
            callLocalFail("method nil Error")
            return
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let body = self.params?.data(using:String.Encoding.utf8, allowLossyConversion: false) {
            request.httpBody = body
        }
    
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        
        session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                DispatchQueue.main.async { self.callLocalFail(String(describing:error)) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { self.callLocalFail("Data가 비정상입니다.") }
                return
            }
            DispatchQueue.main.async {   
                self.callSuccess(data)
            }
        }.resume()
    }
    
    public func convertToDictionary(text: String) -> NSDictionary? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    private func callSuccess(_ params: Data) {
        self.successClosure?(params)
    }
    private func callLocalFail(_ params: String) {
        self.localFailClosure?(params)
    }
    
    public func uploadImageWithData(url: String, images: [UIImage]? = nil, method: HTTPMethod, paramName: String,  parameters: [String: Any]? = nil, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let sUrl = url
        let url = URL(string: sUrl)
        let boundary = "---------------------------"+String(format: "x", Date().toMillis());
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        
        if let parameters = parameters {
            parameters.forEach { (key, value) in
                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                data.append("\(value)\r\n".data(using: .utf8)!)
            }
        }
        if let images = images, images.count > 0 {
            
            for image in images {
                if let imgData = image.getData {
                    let r = arc4random()
                    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                    data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"j\(r).png\"\r\n".data(using: .utf8)!)
                    data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                    data.append(imgData)
                }
            }
        }
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        
        let urlconfig = URLSessionConfiguration.ephemeral
        urlconfig.isDiscretionary = false
        urlconfig.timeoutIntervalForRequest = 1000
        urlconfig.timeoutIntervalForResource = 1000 * 1000
        let session = URLSession(configuration: urlconfig)
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: completionHandler).resume()
    }
    
    public static func requestCustom(url: String,
                                     failed: @escaping ((String)->Void),
                                     success: @escaping ((Data)->Void)) {

        guard let requestUrl = URL(string: url) else {
            failed("url Error")
            return
        }
        let session = URLSession.shared

        let dataTask = session.dataTask(with: requestUrl) { (data, response, error) in
            if data != nil {
                success(data!)
            }
            else {
                failed("nil Error")
            }
        }
        dataTask.resume()
    }
    
    
    public static func getQueryString(querys: [String:Any]) -> String {
        var isFirst = true
        var url = "?"
        for item in querys {
            if !isFirst {
                url.append("&")
            }
            isFirst = false
            
            url.append(item.key)
            url.append("=")
            if let strValue = item.value as? String {
                url.append(strValue)
            }
            if let strValue = item.value as? Int {
                url.append("\(strValue)")
            }
            if let strValue = item.value as? CGFloat {
                url.append("\(strValue)")
            }
            
        }
        return url
    }
    
    public static func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()

        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {

            return false

        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
    }
}
