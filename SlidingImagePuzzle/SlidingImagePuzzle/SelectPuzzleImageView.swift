//
//  SelectPuzzleImageView.swift
//  SlidingImagePuzzle
//
//  Created by Stefan Vainberg on 10/20/14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

import Foundation
import UIKit

protocol SelectPuzzleImageViewDelegate
{
    func didSelectImageCollectionButton() -> Void
}

class SelectPuzzleImageView : UIView
{
    
    var delegate:SelectPuzzleImageViewDelegate?
    // INITIALIZERS
    
    convenience override init()
    {
        self.init(frame:CGRectZero)
        self.setupViewBorder()
        self.setupInternalImage()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // SETUP VIEW
    func setupViewBorder() -> Void
    {
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1.5
        self.layer.cornerRadius = 3.0
    }
    
    func setupInternalImage() -> Void
    {
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        // attach the button image to select any images for the puzzle
        
        let buttonImage = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("cameraRollCollection@2x", ofType: "png")!)
        let imageButton = UIButton()
        imageButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageButton.setImage(buttonImage, forState: UIControlState.Normal)
        imageButton.addTarget(self, action: "didSelectImageCollectionButton", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(imageButton)
        
        // setup constraints for this button
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: imageButton, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: imageButton, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: imageButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 44))
        
        self.addConstraint(NSLayoutConstraint(item: imageButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 44))
        
    }
    
    // BUTTON CALLBACKS
    func didSelectImageCollectionButton() -> Void
    {
        if let del = self.delegate
        {
            del.didSelectImageCollectionButton()
        }
    }

}