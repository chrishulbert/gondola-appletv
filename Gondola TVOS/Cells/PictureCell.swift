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
        label.font = K.labelFont
        label.alpha = 0
        addSubview(label)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = bounds.width
        let h = bounds.height
        let labelHeight = ceil(K.labelFont.lineHeight)
        let imageNormalWidth = floor(w / K.focusGrowth)
        let imageNormalHeight = floor((h - 2 * labelHeight) / K.focusGrowth)
        
        image.frame = CGRect(x: round(w/2 - imageNormalWidth/2), y: round((h - 1.5*labelHeight)/2 - imageNormalHeight/2), width: imageNormalWidth, height: imageNormalHeight)
        label.frame = CGRect(x: 0, y: h - labelHeight, width: w, height: labelHeight)
    }
    
    /// Best height for the given width.
    /// Aspect ratio is such that when multiplied by width, it gives height.
    static func height(forWidth: CGFloat, imageAspectRatio: CGFloat) -> CGFloat {
        let labelHeight = ceil(K.labelFont.lineHeight)
        let imageHeight = round(forWidth * imageAspectRatio)
        return labelHeight * 2 + imageHeight
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)

        let newAlpha: CGFloat = isFocused ? 1 : 0
        coordinator.addCoordinatedAnimations({
            self.label.alpha = newAlpha
        }, completion: nil)
    }
    
//    override var isHighlighted: Bool {
//    }
    
//    override var isSelected: Bool {
//        didSet {
//            let newAlpha: CGFloat = isSelected ? 1 : 0
//            UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: {
//                self.label.alpha = newAlpha
//            }, completion: nil)
//        }
//    }
    
    struct K {
        // When focused, grows from 360 to 407 Horiz (1.13)
        // 540 to 610 (1.13x)
        static let focusGrowth: CGFloat = 1.13
        static let labelFont = UIFont.systemFont(ofSize: 30, weight: UIFontWeightThin)
    }
        
}
