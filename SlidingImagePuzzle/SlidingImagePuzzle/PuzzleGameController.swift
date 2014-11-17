//
//  PuzzleGameController.swift
//  SlidingImagePuzzle
//
//  Created by Stefan Vainberg on 11/8/14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

import Foundation
import UIKit

class PuzzleGameController
{
    
    var currentBlackedOutImage:UIImageView
    
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
                
                println("\(images[blackImageRowInArray][blackImageColumnInArray])   \(blackImage)")
            //}
        }
        
        return generator
    }
    
    func GenerateInitialGameTileMovements(numInitialMovements:Int, inout imagesArray: [[UIImageView]], illegalTouchDirection:TouchDirection) -> Void
    {
        if (numInitialMovements == 0) {return}
        
        // find the current blacked out image's position in the array.
        let blackImageRowInArray = Int ( floor(currentBlackedOutImage.frame.origin.y / currentBlackedOutImage.bounds.size.height)  )
        let blackImageColumnInArray = Int ( floor(currentBlackedOutImage.frame.origin.x / currentBlackedOutImage.bounds.size.width) )
        
        // figure out every potential piece that could move in its place
        var potentialMoveablePiecesArray:[UIImageView] = Array()
        var potentialMoveablePiecesTouchDirectionArray:[TouchDirection] = Array()
 
        // see if a piece exists on top of this one
        if (blackImageRowInArray > 0 && illegalTouchDirection != TouchDirection.Down)
        {
            let imageOnTopOfBlackPiece = imagesArray[blackImageRowInArray - 1][blackImageColumnInArray]
            potentialMoveablePiecesArray.append(imageOnTopOfBlackPiece)
            potentialMoveablePiecesTouchDirectionArray.append(TouchDirection.Up)

        }
        
        // see if a piece exists to the left of this one
        if (blackImageColumnInArray > 0 && illegalTouchDirection != TouchDirection.Right)
        {
            let imageToLeftOfBlackPiece = imagesArray[blackImageRowInArray][blackImageColumnInArray - 1]
            potentialMoveablePiecesArray.append(imageToLeftOfBlackPiece)
            potentialMoveablePiecesTouchDirectionArray.append(TouchDirection.Left)

        }
        
        // see if a piece exists underneath this one
        if (blackImageRowInArray+1 < imagesArray.count && illegalTouchDirection != TouchDirection.Up)
        {
            let imageUnderneathBlackPiece = imagesArray[blackImageRowInArray + 1][blackImageColumnInArray]
            potentialMoveablePiecesArray.append(imageUnderneathBlackPiece)
            potentialMoveablePiecesTouchDirectionArray.append(TouchDirection.Down)


        }
        
        // see if a piece exists to the right of this one
        if (blackImageColumnInArray + 1 < imagesArray[0].count && illegalTouchDirection != TouchDirection.Left)
        {
            let imageToRightOfBlackPiece = imagesArray[blackImageRowInArray][blackImageColumnInArray + 1]
            potentialMoveablePiecesArray.append(imageToRightOfBlackPiece)
            potentialMoveablePiecesTouchDirectionArray.append(TouchDirection.Right)

        }
        
        
        // randomly choose one of these pieces to move over the black piece
        let randomlyChosenPieceIndex = arc4random_uniform(UInt32(potentialMoveablePiecesArray.count))
        let randomlyChosenImageView:UIImageView = potentialMoveablePiecesArray[Int(randomlyChosenPieceIndex)] as UIImageView
        let randomlyChosenIllegalTouchDirection:TouchDirection = potentialMoveablePiecesTouchDirectionArray[Int(randomlyChosenPieceIndex)] as TouchDirection
        randomlyChosenImageView.layer.zPosition = 100;
        
        // modify the images array to reflect the new state
        let randomlyChosenPieceRowInArray = Int ( floor(randomlyChosenImageView.frame.origin.y / randomlyChosenImageView.bounds.size.height)  )
        let randomlyChosenPieceColumnInArray = Int ( floor(randomlyChosenImageView.frame.origin.x / randomlyChosenImageView.bounds.size.width) )
        imagesArray[blackImageRowInArray][blackImageColumnInArray] = randomlyChosenImageView
        imagesArray[randomlyChosenPieceRowInArray][randomlyChosenPieceColumnInArray] = self.currentBlackedOutImage
        
        
        // now we want to animate moving this randomly chosen piece to where the black piece was
        let randomlyChosenImageViewInitialCenter = randomlyChosenImageView.center

        
        UIView.animateWithDuration(0.05, animations: { () -> Void in
            randomlyChosenImageView.center = self.currentBlackedOutImage.center
        }) { (Bool) -> Void in
            self.currentBlackedOutImage.center = randomlyChosenImageViewInitialCenter
            self.GenerateInitialGameTileMovements(numInitialMovements-1, imagesArray: &imagesArray, illegalTouchDirection: randomlyChosenIllegalTouchDirection)
        }

        
        
        

    }
    
}