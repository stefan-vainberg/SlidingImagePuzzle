//
//  PuzzleBoardViewController.swift
//  SlidingImagePuzzle
//
//  Created by Stefan Vainberg on 11/8/14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

import Foundation
import UIKit

protocol PuzzleBoardViewControllerDelegate
{
    func didFinishGeneratingPuzzle() -> Void
}

class PuzzleBoardViewController : UIViewController
{
    // PRIVATE
    var initialImage:UIImage?
    var puzzleBoardView:PuzzleBoardView?
    var puzzleGameController:PuzzleGameController?
    var delegate:PuzzleBoardViewControllerDelegate?
    
    var puzzlePieces:([[UIImage]])?
    var puzzlePieceSize:CGFloat?

    
    convenience init(image:UIImage)
    {
        self.init()
        initialImage = image
        puzzlePieceSize = 150
        self.puzzlePieces = []

        
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience override init()
    {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        
        super.loadView()
        self.view = UIView()
        self.view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        puzzleBoardView = PuzzleBoardView(initialImage: initialImage!)
        puzzleBoardView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        puzzleBoardView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(puzzleBoardView!)
        
        // constraint puzzle image view to the superview
        
        self.view.addConstraint(NSLayoutConstraint(item: puzzleBoardView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: puzzleBoardView!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: puzzleBoardView!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: puzzleBoardView!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetupGamePieces()
        
        // update the board with the pieces
        self.puzzleBoardView!.UpdateWithPuzzlePieces(self.puzzlePieces!)
        self.view.removeConstraints(self.view.constraints())
        
        self.view.addConstraint(NSLayoutConstraint(item: puzzleBoardView!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: self.puzzleBoardView!.boardGameSize!.width))
        
        self.view.addConstraint(NSLayoutConstraint(item: puzzleBoardView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: self.puzzleBoardView!.boardGameSize!.height))
       
        self.view.addConstraint(NSLayoutConstraint(item: puzzleBoardView!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: puzzleBoardView!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        self.delegate!.didFinishGeneratingPuzzle()
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.BeginGame()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // INITIAL BOARD GENERATION
    
    // Setup
    func SetupGamePieces() -> Void
    {
        // figure out the size of the image, and use that to calculate individual puzzle squares
        let numRows = floor(initialImage!.size.height / CGFloat(puzzlePieceSize!))
        let numColumns = floor(initialImage!.size.width / CGFloat(puzzlePieceSize!))
        
        // instantiate the imagePieces
        for row in 0..<Int(numRows)
        {
            self.puzzlePieces!.append(Array(count: Int(numColumns), repeatedValue: UIImage()))
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(initialImage!.size.width, initialImage!.size.height), false, 1.0)
        initialImage!.drawInRect(CGRectMake(0, 0, initialImage!.size.width, initialImage!.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        for (var row = 0; row < Int(numRows); row++)
        {
            for var column = 0; column < Int(numColumns); column++
            {
                let croppedRect = CGRectMake(CGFloat(column)*puzzlePieceSize!, CGFloat(row)*puzzlePieceSize!, puzzlePieceSize!, puzzlePieceSize!)
                let gamePuzzleImageCGImage = CGImageCreateWithImageInRect(image.CGImage, croppedRect)
                let puzzlePiece = UIImage(CGImage: gamePuzzleImageCGImage, scale: 1.0, orientation: initialImage!.imageOrientation)
                puzzlePieces![row][column] = puzzlePiece!
            }
        }
    }
    
    func BeginGame() -> Void
    {
        // first step is to black out one random piece, thereby removing it from the image. This is now the piece that can be moved over
        let randomRow = arc4random_uniform(UInt32(self.puzzlePieces!.count))
        let randomColumn = arc4random_uniform(UInt32(self.puzzlePieces![0].count))
        self.puzzleBoardView!.BlackOutPiece((Int(randomRow), Int(randomColumn)))
        
        let blackImageView = puzzleBoardView!.board![Int(randomRow)][Int(randomColumn)]
        
        let initialGameGenerator = PuzzleGameController(blackedOutImage: blackImageView)
        initialGameGenerator.GenerateInitialGameTileMovements(200, imagesArray: &self.puzzleBoardView!.board!, illegalTouchDirection: TouchDirection.None)
        
        //initialGameGenerator(blackImageView, &puzzleBoardView!.board!)
        
        
    }
    
}