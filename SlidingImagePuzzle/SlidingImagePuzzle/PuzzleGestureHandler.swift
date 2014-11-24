//
//  PuzzleGestureHandler.swift
//  SlidingImagePuzzle
//
//  Created by Stefan Vainberg on 11/9/14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

import Foundation
import UIKit

enum TouchDirection
{
    case Up
    case Down
    case Left
    case Right
    case None
}

protocol PuzzleGestureHandlerDelegate
{
    func didBeginPuzzleGesture(touchPoint:CGPoint)
    func didMovePuzzleGesture(startingTouchPoint:CGPoint, currentTouchPoint:CGPoint, direction:TouchDirection)
    func didCompletePuzzleGesture(startingTouchPoint:CGPoint, currentTouchPoint:CGPoint, direction:TouchDirection)
}

class PuzzleGestureHandler : UIGestureRecognizer
{
    
    // public variables
    var puzzleGameDelegate:PuzzleGestureHandlerDelegate?
    
    // private variables
    private var previousPoint:CGPoint?
    private var currentPoint:CGPoint?
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesBegan(touches, withEvent: event)
        previousPoint = touches.anyObject()!.locationInView(self.view)
        self.puzzleGameDelegate!.didBeginPuzzleGesture(previousPoint!)
        
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesMoved(touches, withEvent: event)
        currentPoint = touches.anyObject()!.locationInView(self.view)
        
        let touchDirection = self.getTouchDirection(previousPoint!, currPoint: currentPoint!)
        self.puzzleGameDelegate!.didMovePuzzleGesture(previousPoint!, currentTouchPoint: currentPoint!, direction: touchDirection)
        previousPoint = currentPoint
        
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesEnded(touches, withEvent: event)
        currentPoint = touches.anyObject()!.locationInView(self.view)
        let touchDirection = self.getTouchDirection(previousPoint!, currPoint: currentPoint!)

        self.puzzleGameDelegate!.didCompletePuzzleGesture(previousPoint!, currentTouchPoint: currentPoint!, direction: touchDirection)
    }
    
    func getTouchDirection(startPt:CGPoint, currPoint:CGPoint) -> TouchDirection
    {
        // try to figure out which direction the user is moving in
        let horizontalDirection = currPoint.x - startPt.x
        let verticalDirection = currPoint.y - startPt.y
        var touchDirection:TouchDirection = TouchDirection.None
        
        if (abs(horizontalDirection) >= abs(verticalDirection)) {
            // we are moving either left or right
            if (horizontalDirection < 0) {
                touchDirection = .Left
            }
            else {
                touchDirection = .Right;
            }
        }
        else {
            if (verticalDirection < 0) {
                touchDirection = .Up
            }
            else {
                touchDirection = .Down;
            }
            
        }
        
        return touchDirection

    }
    
}