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
    var board:([[UIImageView]])?
    
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
        // add the reference holder of pieces
        board = []
        
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
        var fullColumn:[UIImageView] = []
        var imageTag = 0
        for row in pieces
        {
            for image in row
            {
                let correspondingImageView = UIImageView(image: image)
                correspondingImageView.tag = imageTag
                correspondingImageView.frame = CGRectMake(CGFloat(currentColumn)*(image.size.width+1), CGFloat(currentRow)*(image.size.height+1), image.size.width, image.size.height)
                self.addSubview(correspondingImageView)
                fullColumn.append(correspondingImageView)
                currentColumn++
                imageTag++
            }
            board!.append(fullColumn)
            fullColumn = []
            currentRow++
            currentColumn = 0
        }
    }
    
    func UpdateWithImage(image:UIImage) -> Void
    {
        internalImageView!.image = image
    }
    
    func BlackOutPiece(pieceLocation:(row:Int, column:Int))
    {
        let pieceToBlackOut = board![pieceLocation.row][pieceLocation.column]
        let blackView = UIView(frame: CGRectMake(0, 0, pieceToBlackOut.bounds.size.width, pieceToBlackOut.bounds.size.height))
        blackView.backgroundColor = UIColor.blackColor()
        blackView.alpha = 1.0
        pieceToBlackOut.addSubview(blackView)
    }
    
    func PieceAtPoint(point:CGPoint) -> UIImageView
    {
        let locationOfPiece = self.arrayLocationOfPiece(point)
        return board![locationOfPiece.row][locationOfPiece.column]
    }
    
    func arrayLocationOfPiece(point:CGPoint) -> (row:Int, column:Int)
    {
        let samplePiece = board![0][0]
        let samplePieceSize = samplePiece.bounds.size
        
        // figure out which row and column the piece is in
        var pieceAtPointRow:Int = Int( floor(point.y / samplePieceSize.height) )
        var pieceAtPointColumn:Int = Int( floor(point.x / samplePieceSize.width) )
        
        if (pieceAtPointColumn >= board![0].count) {
            pieceAtPointColumn = board![0].count - 1
        }
        if (pieceAtPointRow >= board!.count) {
            pieceAtPointRow = board!.count - 1
        }

        
        return (pieceAtPointRow, pieceAtPointColumn)
    }
    
}