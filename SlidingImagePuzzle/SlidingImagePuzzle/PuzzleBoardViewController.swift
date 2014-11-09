//
//  PuzzleBoardViewController.swift
//  SlidingImagePuzzle
//
//  Created by Stefan Vainberg on 11/8/14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

import Foundation
import UIKit

class PuzzleBoardViewController : UIViewController
{
    // PRIVATE
    var initialImage:UIImage?
    var puzzleBoardView:PuzzleBoardView?
    
    convenience init(image:UIImage)
    {
        self.init()
        initialImage = image
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

