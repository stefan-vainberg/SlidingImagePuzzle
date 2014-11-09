//
//  PuzzleBoardView.swift
//  SlidingImagePuzzle
//
//  Created by Stefan Vainberg on 11/8/14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

import Foundation
import UIKit

class PuzzleBoardView : UIView
{
    
    //PRIVATES
    private var internalImageView:UIImageView?
    
    // INITS
    convenience init(initialImage:UIImage)
    {
        self.init(frame:CGRectZero)
        self.initializeView(initialImage)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // GENERIC INITIALIZER
    func initializeView(image:UIImage) -> Void
    {
        self.backgroundColor = UIColor.blackColor()
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        internalImageView = UIImageView(image: image)
        internalImageView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(internalImageView!)
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: internalImageView!, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: internalImageView!, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: internalImageView!, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: internalImageView!, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))

    }
}