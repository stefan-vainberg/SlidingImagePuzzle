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
    func didMovePuzzleGesture(startingTouchPoint:CGPoint, currentTouchPoint:CGPoint, direction:TouchDirection)
    func didCompletePuzzleGesture(startingTouchPoint:CGPoint, direction:TouchDirection)
}

class PuzzleGestureHandler : UIGestureRecognizer
{
    
    
    // private variables
    private var startingPoint:CGPoint?
    private var currentPoint:CGPoint?
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesBegan(touches, withEvent: event)
        startingPoint = touches.anyObject()!.locationInView(self.view)
        
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesEnded(touches, withEvent: event)
        currentPoint = touches.anyObject()!.locationInView(self.view)
        
        
        // try to figure out which direction the user is moving in
        let horizontalDirection = currentPoint!.x - startingPoint!.x
        let verticalDirection = currentPoint!.y - startingPoint!.y
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesEnded(touches, withEvent: event)
    }
    
}