//
//  NetworkingClient.swift
//  notes
//
//  Created by Jan Bednar on 16/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import PromiseKit
import Alamofire

protocol NetworkClient {
    func make<T: NetworkRequest>(dataRequest: T) -> Promise<T.Response>
    func make<T: NetworkRequest>(request: T) -> Promise<Void>
}

class NetworkClientImpl: NetworkClient {
    
    private let sessionManager: SessionManager
    private let dispatchQueue: DispatchQueue
    private let decoder: JSONDecoder
    
    init(sessionManager: SessionManager = SessionManager.default, dispatchQueue: DispatchQueue = DispatchQueue.main, decoder: JSONDecoder = JSONDecoder()) {
        self.sessionManager = sessionManager
        self.dispatchQueue = dispatchQueue
        self.decoder = decoder
    }
    
    func make<T: NetworkRequest>(dataRequest: T) -> Promise<T.Response> {
        return Promise(resolver: { resolver in
            let request = sessionManager.request(dataRequest)
            request.validate()
                .responseData(queue: dispatchQueue, completionHandler: { [weak self] response in
                    self?.handle(response, for: request, resolver: resolver)
                })
        })
    }
    
    func make<T: NetworkRequest>(request: T) -> Promise<Void> {
        return Promise(resolver: { resolver in
            let request = sessionManager.request(request)
            request.validate()
                .response(queue: dispatchQueue, completionHandler: { response in
                    resolver.resolve(response.error)
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
