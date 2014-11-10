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
    
    // PUBLICS
    var boardGameSize:CGSize?
    
    //PRIVATES
    private var internalImageView:UIImageView?
    private var puzzleGestureRecognizer:PuzzleGestureHandler?
    
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
        
        // add the recognizer
        puzzleGestureRecognizer = PuzzleGestureHandler()
        self.addGestureRecognizer(puzzleGestureRecognizer!)
        
        
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1.0
        internalImageView = UIImageView(image: image)
        
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        internalImageView!.setTranslatesAutoresizingMaskIntoConstraints(false)

        self.addSubview(internalImageView!)
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: internalImageView!, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: internalImageView!, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0))

        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: internalImageView!, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: internalImageView!, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
    }
    
    func UpdateWithPuzzlePieces(pieces:[[UIImage]]) -> Void
    {
        let sampleImage = pieces[0][0]
        
        let totalHeight = CGFloat(pieces.count) * sampleImage.size.height
        let totalWidth = CGFloat(pieces[0].count) * sampleImage.size.width
        boardGameSize = CGSizeMake(totalWidth, totalHeight)
        
        self.removeConstraints(self.constraints())
        self.backgroundColor = UIColor.blackColor()

        internalImageView!.removeFromSuperview()
        
        var currentRow = 0
        var currentColumn = 0
        for row in pieces
        {
            for image in row
            {
                let correspondingImageView = UIImageView(image: image)
                correspondingImageView.frame = CGRectMake(CGFloat(currentColumn)*(image.size.width+1), CGFloat(currentRow)*(image.size.height+1), image.size.width, image.size.height)
                self.addSubview(correspondingImageView)
                currentColumn++
            }
            currentRow++
            currentColumn = 0
        }
    }
    
    func UpdateWithImage(image:UIImage) -> Void
    {
        internalImageView!.image = image
    }
    
    
}