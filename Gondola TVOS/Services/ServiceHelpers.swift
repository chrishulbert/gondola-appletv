//
//  ServiceHelpers.swift
//  Gondola TVOS
//
//  Created by Chris Hulbert on 8/2/17.
//  Copyright © 2017 Chris Hulbert. All rights reserved.
//

import Foundation

struct ServiceHelpers {
    
    typealias JsonResult = Result<[AnyHashable: Any]>
    
    /// Returns on any thread.
    static func request(path: String, completion: @escaping (JsonResult) -> ()) {
        guard let url = URL(string: path, relativeTo: K.baseUrl) else {
            completion(.failure(ServiceError.badUrl))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            completion(result(data: data, response: response, error: error))
        }
        task.resume()
    }
    
    fileprivate static func result(data: Data?, response: URLResponse?, error: Error?) -> JsonResult {
        if let error = error {
            return .failure(error)
        }
        if let response = response as? HTTPURLResponse, response.statusCode > 400 {
            return .failure(ServiceError.httpError(response.statusCode))
        }
        guard let data = data else {
            return .failure(ServiceError.noData)
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return .failure(ServiceError.notJson)
        }
        guard let dict = json as? [AnyHashable: Any] else {
            return .failure(ServiceError.notDictionary)
        }
        return .success(dict)
    }
    
    struct K {
        static let baseUrl = URL(string: "http://gondola")!
    }

    enum ServiceError: Error {
        case badUrl
        case httpError(Int)
        case noData
        case notJson
        case notDictionary
    }

}
