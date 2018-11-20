//
//  RestApi.swift
//  fridge-qr
//
//  Created by Vicente Cantu Garcia on 11/20/18.
//  Copyright © 2018 Vicente Cantu Garcia. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

//fileprivate let baseURL = "https://mysterious-crag-75420.herokuapp.com"
fileprivate let baseURL = "http://localhost:3000"

typealias Response = Mappable
typealias Request = Mappable
typealias HandlerResponse<T: Mappable> = (T) -> Void
typealias HandlerResponseArray<T: Mappable> = ([T]) -> Void
typealias HandlerError = (Data?) -> Void
typealias HandlerGeneric = (Any?) -> Void

protocol AlamofireEndPoint {
    
    func provideValues() -> (url: String, httpMethod: HTTPMethod, parameters: Request?)
    var url: String { get }
    var httpMethod: HTTPMethod { get }
    var parameters: Request? { get }
    
}

extension AlamofireEndPoint {
    
    var url: String { return baseURL + provideValues().url }
    var httpMethod: HTTPMethod { return provideValues().httpMethod }
    var parameters: Request? { return provideValues().parameters }
    var headers: HTTPHeaders { return [:] }
    
}

class RestApi {
    
    static func callObject<T: Response>(to endPoint: AlamofireEndPoint,
                                        onResponse: @escaping HandlerResponse<T>,
                                        onError: @escaping HandlerError,
                                        notConnection: @escaping HandlerGeneric,
                                        function: String) {
        var parameters: [String: Any] = [:]
        parameters = endPoint.parameters?.toJSON() ?? [:]
        Alamofire.request(endPoint.url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!, method: endPoint.httpMethod, parameters: parameters, encoding: JSONEncoding.default,
                          headers: endPoint.headers).validate().responseObject { (response: DataResponse<T>) in
                            print("Function: \(function)")
                            if NetworkReachabilityManager()!.isReachable {
                                if response.result.isSuccess {
                                    onResponse(response.result.value!)
                                } else {
                                    print(response.error?.localizedDescription ?? "ERROR")
                                    onError(response.data)
                                    
                                }
                                
                            } else {
                                notConnection(nil)
                                
                            }
                            
        }
        
    }
    
    
    /// Use HandlerResponseArray in onResponse
    static func callObject<T: Response>(to endPoint: AlamofireEndPoint,
                                        onResponse: @escaping HandlerResponseArray<T>,
                                        onError: @escaping HandlerError,
                                        notConnection: @escaping HandlerGeneric,
                                        function: String) {
        var parameters: [String: Any] = [:]
        parameters = endPoint.parameters?.toJSON() ?? [:]
        Alamofire.request(endPoint.url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!, method: endPoint.httpMethod, parameters: parameters, encoding: JSONEncoding.default,
                          headers: endPoint.headers).validate().responseArray { (response: DataResponse<[T]>) in
                            print("Function: \(function)")
                            if NetworkReachabilityManager()!.isReachable {
                                if response.result.isSuccess {
                                    onResponse(response.result.value!)
                                    
                                } else {
                                    print(response.error?.localizedDescription ?? "ERROR")
                                    onError(response.data)
                                }
                                
                            } else {
                                notConnection(nil)
                                
                            }
        }
    }
    
}

