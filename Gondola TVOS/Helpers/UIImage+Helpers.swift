//
//  UIImage+Helpers.swift
//  Gondola TVOS
//
//  Created by Chris Hulbert on 23/3/17.
//  Copyright © 2017 Chris Hulbert. All rights reserved.
//

import UIKit

// https://github.com/Alamofire/AlamofireImage/blob/master/Source/UIImage%2BAlamofireImage.swift

extension UIImage {
    private struct AssociatedKey {
        static var inflated = "af_UIImage.Inflated"
    }
    
    /// Returns whether the image is inflated.
    public var af_inflated: Bool {
        get {
            if let inflated = objc_getAssociatedObject(self, &AssociatedKey.inflated) as? Bool {
                return inflated
            } else {
                return false
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.inflated, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Inflates the underlying compressed image data to be backed by an uncompressed bitmap representation.
    ///
    /// Inflating compressed image formats (such as PNG or JPEG) can significantly improve drawing performance as it
    /// allows a bitmap representation to be constructed in the background rather than on the main thread.
    public func af_inflate() {
        guard !af_inflated else { return }
        
        af_inflated = true
        _ = cgImage?.dataProvider?.data
    }
}
