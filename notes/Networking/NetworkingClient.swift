//
//  NetworkingClient.swift
//  notes
//
//  Created by Jan Bednar on 16/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import PromiseKit
import Alamofire

protocol NetworkingClient {
    func make<T: NetworkRequest>(request: T) -> Promise<T.Response>
}

class NetworkingClientImpl: NetworkingClient {
    
    private let sessionManager: SessionManager
    private let dispatchQueue: DispatchQueue
    private let decoder: JSONDecoder
    
    init(sessionManager: SessionManager = SessionManager.default, dispatchQueue: DispatchQueue = DispatchQueue.main, decoder: JSONDecoder = JSONDecoder()) {
        self.sessionManager = sessionManager
        self.dispatchQueue = dispatchQueue
        self.decoder = decoder
    }
    
    func make<T>(request: T) -> Promise<T.Response> where T : NetworkRequest {
        return Promise(resolver: { resolver in
            let request = sessionManager.request(request)
            request.validate()
                .responseData(queue: dispatchQueue, completionHandler: { [weak self] response in
                    self?.handle(response, for: request, resolver: resolver)
                })
        })
    }
    
    private func handle<T: Decodable>(_ response: DataResponse<Data>, for request: DataRequest, resolver: Resolver<T>) {
        switch response.result {
        case .success(let value):
            do {
                let response = try decoder.decode(T.self, from: value)
                resolver.fulfill(response)
            } catch {
                resolver.reject(error)
            }
        case .failure(let error):
            resolver.reject(error)
        }
    }
}
