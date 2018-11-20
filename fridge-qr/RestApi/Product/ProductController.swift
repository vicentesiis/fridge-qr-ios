//
//  ProductController.swift
//  fridge-qr
//
//  Created by Vicente Cantu Garcia on 11/20/18.
//  Copyright © 2018 Vicente Cantu Garcia. All rights reserved.
//

import Foundation
import Alamofire

enum ProductEndPoint: AlamofireEndPoint {
    case products()
    case product(id: String)
    case deleteProduct(id: String)
    case createProduct(parameters: Request?)
    case editProduct(parameters: Request?)

    func provideValues() -> (url: String, httpMethod: HTTPMethod, parameters: Request?) {
        switch self {
        case .products():
            return (url: "/product", httpMethod: .get, parameters: nil)
        case .product(let id):
            return (url: "/product\(id)", httpMethod: .get, parameters: nil)
        case .deleteProduct(let id):
            return (url: "/product\(id)", httpMethod: .delete, parameters: nil)
        case .createProduct(let body):
            return (url: "/product", httpMethod: .post, parameters: (body != nil) ? body : nil)
        case .editProduct(let body):
            return (url: "/product", httpMethod: .put, parameters: (body != nil) ? body : nil)
        }
    }
}

class ProductJSON {

    static func getProducts(page: Int = 1, onResponse: @escaping HandlerResponseArray<Product>, onError: @escaping HandlerError, notConnection: @escaping HandlerGeneric) {
        RestApi.callObject(to: ProductEndPoint.products(), onResponse: onResponse, onError: onError, notConnection: notConnection, function: #function)
    }
    
    static func getProduct(id: String?, onResponse: @escaping HandlerResponse<Product>, onError: @escaping HandlerError, notConnection: @escaping HandlerGeneric) {
        RestApi.callObject(to: ProductEndPoint.product(id: id ?? ""), onResponse: onResponse, onError: onError, notConnection: notConnection, function: #function)
    }
    
    static func createProduct(body: ProductObject?, onResponse: @escaping HandlerResponse<Product>, onError: @escaping HandlerError, notConnection: @escaping HandlerGeneric) {
        RestApi.callObject(to: ProductEndPoint.createProduct(parameters: body), onResponse: onResponse, onError: onError, notConnection: notConnection, function: #function)
    }
    
    static func putProducts(body: ProductObject?, onResponse: @escaping HandlerResponse<Product>, onError: @escaping HandlerError, notConnection: @escaping HandlerGeneric) {
        RestApi.callObject(to: ProductEndPoint.editProduct(parameters: body), onResponse: onResponse, onError: onError, notConnection: notConnection, function: #function)
    }
    
    

}
