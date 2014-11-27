//
//  PuzzleGameController.swift
//  SlidingImagePuzzle
//
//  Created by Stefan Vainberg on 11/8/14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

import Foundation
import UIKit

protocol PuzzleGameControllerDelegate
{
    func didFinishInitialGameGeneration(imagesArray:[[UIImageView]]) -> Void
}

class PuzzleGameController
{
    
    var currentBlackedOutImage:UIImageView
    var delegate:PuzzleGameControllerDelegate?
    
    init(blackedOutImage:UIImageView)
    {
        currentBlackedOutImage = blackedOutImage
    }
    
    class func GenerateInitialGameTileMovements(numInitialMovements:Int) -> (UIImageView, inout [[UIImageView]]) -> Void
    {
        // the rect is the target, and we want to return the imageView that should be moved into that rect
        let generator = {(blackImage:UIImageView, inout images:[[UIImageView]]) -> Void in
            //for var i = 0; i < numInitialMovements; i++
            //{
                // figure out which images are adjacent to the current black images
                let blackImageRowInArray    = Int ( floor(blackImage.frame.origin.y / blackImage.bounds.size.height)  )
                let blackImageColumnInArray = Int ( floor(blackImage.frame.origin.x / blackImage.bounds.size.width) )
                
            //}
        }
        
        return generator
    }
    
    func blackedOutImagePosition(imagesArray:[[UIImageView]]) -> (row:Int, column:Int)
    {
        // find the current blacked out image's position in the array.
        var blackImageRowInArray:Int = Int ( floor(currentBlackedOutImage.frame.origin.y / currentBlackedOutImage.bounds.size.height)  )
        var blackImageColumnInArray:Int = Int ( floor(currentBlackedOutImage.frame.origin.x / currentBlackedOutImage.bounds.size.width) )
        
        
        if (blackImageRowInArray >= imagesArray.count) {
            blackImageRowInArray = blackImageRowInArray - 1
        }
        
        if (blackImageColumnInArray >= imagesArray[0].count) {
            blackImageColumnInArray = blackImageColumnInArray - 1
        }


        return (blackImageRowInArray,blackImageColumnInArray)
    }
    
    func GenerateInitialGameTileMovements(numInitialMovements:Int, inout imagesArray: [[UIImageView]], illegalTouchDirection:TouchDirection) -> Void
    {
        if (numInitialMovements == 0) {
            if let theDelegate = self.delegate {
                theDelegate.didFinishInitialGameGeneration(imagesArray)
            }
            return
        }
        
        // find the current blacked out image's position in the array.
        let blackedOutImagePosition = self.blackedOutImagePosition(imagesArray)
        let blackImageRowInArray = blackedOutImagePosition.row
        let blackImageColumnInArray = blackedOutImagePosition.column
        
        // figure out every potential piece that could move in its place
        var potentialMoveablePiecesArray:[UIImageView] = Array()
        var potentialMoveablePiecesTouchDirectionArray:[TouchDirection] = Array()
        var potentialMoveablePiecesLocationInArray:[(Row:Int, Column:Int)] = Array()
 
        // see if a piece exists on top of this one
        if (blackImageRowInArray > 0 && illegalTouchDirection != TouchDirection.Down)
        {
            let imageOnTopOfBlackPiece = imagesArray[blackImageRowInArray - 1][blackImageColumnInArray]
            potentialMoveablePiecesArray.append(imageOnTopOfBlackPiece)
            potentialMoveablePiecesTouchDirectionArray.append(TouchDirection.Up)
            potentialMoveablePiecesLocationInArray.append(Row:Int(blackImageRowInArray - 1), Column:Int(blackImageColumnInArray))

        }
        
        // see if a piece exists to the left of this one
        if (blackImageColumnInArray > 0 && illegalTouchDirection != TouchDirection.Right)
        {
            let imageToLeftOfBlackPiece = imagesArray[blackImageRowInArray][blackImageColumnInArray - 1]
            potentialMoveablePiecesArray.append(imageToLeftOfBlackPiece)
            potentialMoveablePiecesTouchDirectionArray.append(TouchDirection.Left)
            potentialMoveablePiecesLocationInArray.append(Row:Int(blackImageRowInArray), Column:Int(blackImageColumnInArray - 1))

        }
        
        // see if a piece exists underneath this one
        if (blackImageRowInArray+1 < imagesArray.count && illegalTouchDirection != TouchDirection.Up)
        {
            let imageUnderneathBlackPiece = imagesArray[blackImageRowInArray + 1][blackImageColumnInArray]
            potentialMoveablePiecesArray.append(imageUnderneathBlackPiece)
            potentialMoveablePiecesTouchDirectionArray.append(TouchDirection.Down)
            potentialMoveablePiecesLocationInArray.append(Row:Int(blackImageRowInArray + 1), Column:Int(blackImageColumnInArray))
        }
        
        // see if a piece exists to the right of this one
        if (blackImageColumnInArray + 1 < imagesArray[0].count && illegalTouchDirection != TouchDirection.Left)
        {
            let imageToRightOfBlackPiece = imagesArray[blackImageRowInArray][blackImageColumnInArray + 1]
            potentialMoveablePiecesArray.append(imageToRightOfBlackPiece)
            potentialMoveablePiecesTouchDirectionArray.append(TouchDirection.Right)
            potentialMoveablePiecesLocationInArray.append(Row:Int(blackImageRowInArray), Column:Int(blackImageColumnInArray + 1))

        }
        
        
        // randomly choose one of these pieces to move over the black piece
        let randomlyChosenPieceIndex = arc4random_uniform(UInt32(potentialMoveablePiecesArray.count))
        let randomlyChosenImageView:UIImageView = potentialMoveablePiecesArray[Int(randomlyChosenPieceIndex)] as UIImageView
        let randomlyChosenIllegalTouchDirection:TouchDirection = potentialMoveablePiecesTouchDirectionArray[Int(randomlyChosenPieceIndex)] as TouchDirection
        let randomlyChosenPieceIndexInBoard = potentialMoveablePiecesLocationInArray[Int(randomlyChosenPieceIndex)] as (Row:Int, Column:Int)

        randomlyChosenImageView.layer.zPosition = 100;
        
        // modify the images array to reflect the new state
        imagesArray[blackImageRowInArray][blackImageColumnInArray] = randomlyChosenImageView
        imagesArray[randomlyChosenPieceIndexInBoard.Row][randomlyChosenPieceIndexInBoard.Column] = self.currentBlackedOutImage
        
        
        // now we want to animate moving this randomly chosen piece to where the black piece was
        let randomlyChosenImageViewInitialCenter = randomlyChosenImageView.center

        
        UIView.animateWithDuration(0.01, animations: { () -> Void in
            randomlyChosenImageView.center = self.currentBlackedOutImage.center
        }) { (Bool) -> Void in
            self.currentBlackedOutImage.center = randomlyChosenImageViewInitialCenter
            self.GenerateInitialGameTileMovements(numInitialMovements-1, imagesArray: &imagesArray, illegalTouchDirection: randomlyChosenIllegalTouchDirection)
        }
    }
    
    func CheckDidWinGame(imagesArray: [[UIImageView]]) -> Bool
    {
        var currentTag = 0
        for row in imagesArray {
            for image in row {
                if image.tag != currentTag {
                    return false
                }
                currentTag++
            }
        }
        
        return true
    }
    
    func unBlackoutBlackImage() -> Void
    {
        for subview in self.currentBlackedOutImage.subviews {
            subview.removeFromSuperview()
        }
    }
    
}