//
//  PictureCell.swift
//  Gondola TVOS
//
//  Created by Chris on 10/02/2017.
//  Copyright © 2017 Chris Hulbert. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell {
    
    let image = UIImageView()
    let label = UILabel()
    
    var imagePath: String? // For checking for stale image loads on recycled cells.
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        image.adjustsImageWhenAncestorFocused = true
        image.contentMode = .scaleAspectFit
        addSubview(image)
        
        label.textAlignment = .center
        label.textColor = UIColor.white
        addSubview(label)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = bounds.width
        let h = bounds.height

        image.frame = CGRect(x: 0, y: 0, width: w, height: h - K.labelHeight - K.labelGap)
        label.frame = CGRect(x: 0, y: h - K.labelHeight, width: w, height: K.labelHeight)
    }
    
    struct K {
        static let labelHeight: CGFloat = 46
        static let labelGap: CGFloat = 40 // To allow for the growth of the image when selected.

    }
        
}
