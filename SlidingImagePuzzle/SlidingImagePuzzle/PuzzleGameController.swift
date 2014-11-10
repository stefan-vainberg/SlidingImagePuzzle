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
    var gamePuzzleImage:UIImage?
    var puzzlePieces:[[UIImage]]
    var puzzlePieceSize:CGFloat
    
    // INITIALIZER
    init(image:UIImage)
    {
        puzzlePieceSize = 75
        self.gamePuzzleImage = image
        self.puzzlePieces = []
        self.SetupGamePieces()
    }
    
    // Setup
    func SetupGamePieces() -> Void
    {
        // figure out the size of the image, and use that to calculate individual puzzle squares
        let numRows = floor(gamePuzzleImage!.size.height / CGFloat(puzzlePieceSize))
        let numColumns = floor(gamePuzzleImage!.size.width / CGFloat(puzzlePieceSize))
        
        // instantiate the imagePieces
        for row in 0..<Int(numRows)
        {
            self.puzzlePieces.append(Array(count: Int(numColumns), repeatedValue: UIImage()))
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(gamePuzzleImage!.size.width, gamePuzzleImage!.size.height), false, 1.0)
        gamePuzzleImage!.drawInRect(CGRectMake(0, 0, gamePuzzleImage!.size.width, gamePuzzleImage!.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        for (var row = 0; row < Int(numRows); row++)
        {
            for var column = 0; column < Int(numColumns); column++
            {
                let croppedRect = CGRectMake(CGFloat(column)*puzzlePieceSize, CGFloat(row)*puzzlePieceSize, puzzlePieceSize, puzzlePieceSize)
                let gamePuzzleImageCGImage = CGImageCreateWithImageInRect(image.CGImage, croppedRect)
                let puzzlePiece = UIImage(CGImage: gamePuzzleImageCGImage, scale: 1.0, orientation: gamePuzzleImage!.imageOrientation)
                puzzlePieces[row][column] = puzzlePiece!
            }
        }
    }
}