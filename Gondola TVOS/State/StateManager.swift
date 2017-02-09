//
//  StateManager.swift
//  Gondola TVOS
//
//  Created by Chris on 9/02/2017.
//  Copyright © 2017 Chris Hulbert. All rights reserved.
//

import UIKit

class StateManager {
    
    static let shared = StateManager()
    
    var rootNav: UINavigationController!
    
    func appLaunch() {
        requestMetadataUntilSuccess { metadata in
            DispatchQueue.main.async {
                self.rootNav.setViewControllers([TVViewController()], animated: true)
            }
        }
    }

    /// Completes on any thread.
    fileprivate func requestMetadataUntilSuccess(completion: @escaping (GondolaMetadata) -> ()) {
        MetadataService.request {
            switch $0 {
            case .success(let metadata):
                completion(metadata)
                
            case .failure:
                // Wait a second between retries.
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    self.requestMetadataUntilSuccess(completion: completion)
                }
            }
        }
    }
    
}
