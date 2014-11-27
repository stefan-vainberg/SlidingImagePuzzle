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
    func didWinPuzzleGame() -> Void
}

class PuzzleBoardViewController : UIViewController, PuzzleGameControllerDelegate, PuzzleGestureHandlerDelegate
{
    // PRIVATE
    var initialImage:UIImage?
    var puzzleBoardView:PuzzleBoardView?
    var puzzleGameController:PuzzleGameController?
    var delegate:PuzzleBoardViewControllerDelegate?
    var gameController:PuzzleGameController?
    var gameGestureHandler:PuzzleGestureHandler?
    var currentlyMovingPuzzlePiece:UIImageView?
    var currentlyMovingPuzzlePieceInitialOrigin:CGPoint?
    
    var puzzlePieces:([[UIImage]])?
    var puzzlePieceSize:CGFloat?

    
    convenience init(image:UIImage)
    {
        self.init()
        initialImage = image
        puzzlePieceSize = 300
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
        
        gameController = PuzzleGameController(blackedOutImage: blackImageView)
        gameController!.delegate = self
        gameController!.GenerateInitialGameTileMovements(150, imagesArray: &self.puzzleBoardView!.board!, illegalTouchDirection: TouchDirection.None)
    }
    
    // PuzzleGameControllerDelegate
    
    func didFinishInitialGameGeneration(imagesArray:[[UIImageView]]) {
    
        // start processing gestures
        gameGestureHandler = PuzzleGestureHandler()
        gameGestureHandler!.puzzleGameDelegate = self
        puzzleBoardView!.addGestureRecognizer(gameGestureHandler!)
        puzzleBoardView!.board = imagesArray
    }
    
    // PuzzleGestureHandlerDelegate
    
    func didBeginPuzzleGesture(touchPoint: CGPoint) {
        currentlyMovingPuzzlePiece = self.puzzleBoardView!.PieceAtPoint(touchPoint)
        currentlyMovingPuzzlePieceInitialOrigin = currentlyMovingPuzzlePiece!.frame.origin
        
        // we can't move the blacked out piece
        if (currentlyMovingPuzzlePiece == self.gameController!.currentBlackedOutImage) {
            self.gameGestureHandler!.state = UIGestureRecognizerState.Failed
            return
        }
        
        // make sure that the black piece is adjacent to the selected piece
        
        // figure out which puzzle piece is getting touched
        let selectedPiece = currentlyMovingPuzzlePiece!
        let selectedPieceArrayLocation = self.puzzleBoardView!.arrayLocationOfPiece(touchPoint)
        let blackedOutPieceArrayLocation = self.gameController!.blackedOutImagePosition(self.puzzleBoardView!.board!)

        
        if (selectedPieceArrayLocation.row == blackedOutPieceArrayLocation.row || selectedPieceArrayLocation.column == blackedOutPieceArrayLocation.column) {
            // we know that that the black piece is horizontally vertical to our targetted piece. now see if it's within one spot of it
            if (selectedPieceArrayLocation.row > blackedOutPieceArrayLocation.row + 1 || selectedPieceArrayLocation.row < blackedOutPieceArrayLocation.row - 1 || selectedPieceArrayLocation.column > blackedOutPieceArrayLocation.column + 1  || selectedPieceArrayLocation.column < blackedOutPieceArrayLocation.column - 1) {
                self.gameGestureHandler!.state = UIGestureRecognizerState.Failed
                return
            }
        }
        else {
            self.gameGestureHandler!.state = UIGestureRecognizerState.Failed
            return
        }

    }
    
    func didMovePuzzleGesture(startingTouchPoint:CGPoint, currentTouchPoint:CGPoint, direction:TouchDirection) -> Void
    {
        // figure out which puzzle piece is getting touched
        let selectedPiece = currentlyMovingPuzzlePiece!
        let blackedOutPiece = self.gameController!.currentBlackedOutImage
        let selectedPieceArrayLocation = self.puzzleBoardView!.arrayLocationOfPiece(startingTouchPoint)
        let blackedOutPieceArrayLocation = self.gameController!.blackedOutImagePosition(self.puzzleBoardView!.board!)
        
        // figure out the rectangle of possible motion for the piece.
        
        let legalMotionRect = CGRectMake(min(currentlyMovingPuzzlePieceInitialOrigin!.x, blackedOutPiece.frame.origin.x),
            min(currentlyMovingPuzzlePieceInitialOrigin!.y , blackedOutPiece.frame.origin.y),
            max (abs(blackedOutPiece.frame.origin.x + blackedOutPiece.bounds.size.width - (currentlyMovingPuzzlePieceInitialOrigin!.x)),
                 abs(currentlyMovingPuzzlePieceInitialOrigin!.x + currentlyMovingPuzzlePiece!.bounds.size.width - (blackedOutPiece.frame.origin.x))),
            max (abs(blackedOutPiece.frame.origin.y + blackedOutPiece.bounds.size.height - (currentlyMovingPuzzlePieceInitialOrigin!.y)),
                 abs(currentlyMovingPuzzlePieceInitialOrigin!.y + currentlyMovingPuzzlePiece!.bounds.size.height - (blackedOutPiece.frame.origin.y))))
        
        if(direction == TouchDirection.Left || direction == TouchDirection.Right) {
            
            if (legalMotionRect.size.width == selectedPiece.bounds.size.width) {
                return
                // can't move left or right if the black piece is underneath
            }
            
            let frameMovement = currentTouchPoint.x - startingTouchPoint.x
            
            // don't want to move past the legal motion rect
            if (selectedPiece.frame.origin.x + frameMovement < legalMotionRect.origin.x || selectedPiece.frame.origin.x + selectedPiece.bounds.size.width + frameMovement > legalMotionRect.origin.x + legalMotionRect.size.width) {
                return
            }
            
            selectedPiece.frame = CGRectMake(selectedPiece.frame.origin.x + frameMovement, selectedPiece.frame.origin.y, selectedPiece.bounds.size.width, selectedPiece.bounds.size.height)
            
            if (selectedPiece.frame.origin.x < legalMotionRect.origin.x) {
                selectedPiece.frame = CGRectMake(legalMotionRect.origin.x, selectedPiece.frame.origin.y, selectedPiece.bounds.size.width, selectedPiece.bounds.size.height)
            }
            else if (selectedPiece.frame.origin.x + selectedPiece.bounds.size.width > legalMotionRect.origin.x + legalMotionRect.size.width) {
                selectedPiece.frame = CGRectMake(legalMotionRect.origin.x + legalMotionRect.size.width - selectedPiece.bounds.size.width, selectedPiece.frame.origin.y, selectedPiece.bounds.size.width, selectedPiece.bounds.size.height)
            }
        }
        else {
            
            if (legalMotionRect.size.height == selectedPiece.bounds.size.height) {
                return
                // can't move up or down if black piece is to left or right
            }

            
            
            let frameMovement = currentTouchPoint.y - startingTouchPoint.y

            // don't want to move past the legal motion rect
            if (selectedPiece.frame.origin.y + frameMovement < legalMotionRect.origin.y || selectedPiece.frame.origin.y + selectedPiece.bounds.size.height + frameMovement > legalMotionRect.origin.y + legalMotionRect.size.height) {
                return
            }

            
            selectedPiece.frame = CGRectMake(selectedPiece.frame.origin.x, selectedPiece.frame.origin.y + frameMovement, selectedPiece.bounds.size.width, selectedPiece.bounds.size.height)
        }
    }

    
    func didCompletePuzzleGesture(startingTouchPoint: CGPoint, currentTouchPoint: CGPoint, direction: TouchDirection)
    {
        // the blacked out piece needs to be swapped in the board array wih the currently selected piece
        let blackedOutPieceLocation = self.gameController!.blackedOutImagePosition(self.puzzleBoardView!.board!)
        let selectedPieceArrayLocation = self.puzzleBoardView!.arrayLocationOfPiece(CGPointMake(currentlyMovingPuzzlePieceInitialOrigin!.x + currentlyMovingPuzzlePiece!.bounds.size.width/2,
            currentlyMovingPuzzlePieceInitialOrigin!.y + currentlyMovingPuzzlePiece!.bounds.size.height/2))
        
        
        
        let selectedPiece = self.puzzleBoardView!.board![selectedPieceArrayLocation.row][selectedPieceArrayLocation.column]
        
        self.puzzleBoardView!.board![selectedPieceArrayLocation.row][selectedPieceArrayLocation.column] = self.gameController!.currentBlackedOutImage
        self.puzzleBoardView!.board![blackedOutPieceLocation.row][blackedOutPieceLocation.column] = selectedPiece
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
        })
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            selectedPiece.center = self.gameController!.currentBlackedOutImage.center
            }){
                (finished:Bool) -> Void in
                if (finished) {
                    if(self.gameController!.CheckDidWinGame(self.puzzleBoardView!.board!)) {
                        self.didWinGame()
                    }
                }
            }
        self.gameController!.currentBlackedOutImage.center = CGPointMake(currentlyMovingPuzzlePieceInitialOrigin!.x + selectedPiece.bounds.size.width/2,
                                                                         currentlyMovingPuzzlePieceInitialOrigin!.y + selectedPiece.bounds.size.height/2)
    }
    
    func didWinGame() -> Void
    {
        self.gameController!.unBlackoutBlackImage()
        self.delegate!.didWinPuzzleGame()
    }

    
}