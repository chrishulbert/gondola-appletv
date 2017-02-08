//
//  ServiceHelpers.swift
//  Gondola TVOS
//
//  Created by Chris Hulbert on 8/2/17.
//  Copyright © 2017 Chris Hulbert. All rights reserved.
//

import Foundation

struct ServiceHelpers {
    
    static let baseUrl = URL(string: "http://gondola")!
    
    typealias JsonResult = Result<GondolaMetadata>

    static func request(url: URL, completion: @escaping (JsonResult) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                todo completion
            } else {
                
            }
        }
        task.resume()
    }
    
}
