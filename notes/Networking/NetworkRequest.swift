//
//  NetworkRequest.swift
//  notes
//
//  Created by Jan Bednar on 16/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import Alamofire

enum NetworkRequestError: Error {
    case badRequest
}

public protocol NetworkRequest: URLRequestConvertible {
    associatedtype Response: Decodable
    
    static var baseUrlString: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
    var headers: HTTPHeaders? { get }
}

extension NetworkRequest {
    static var baseUrlString: String {
        return server.stringUrl
    }
    
    var headers: HTTPHeaders? {
        let headers = ["Content-Type": "application/json"]
        return headers
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let baseUrl = URL(string: Self.baseUrlString) else {
            throw NetworkRequestError.badRequest
        }
        
        let url = baseUrl.appendingPathComponent(path)
        var request = try URLRequest(url: url, method: method, headers: headers)
        request.httpBody = body
        return request
    }
}
