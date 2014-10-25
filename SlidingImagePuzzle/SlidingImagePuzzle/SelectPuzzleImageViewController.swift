//
//  SelectPuzzleImageViewController.swift
//  SlidingImagePuzzle
//
//  Created by Stefan Vainberg on 10/20/14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

import Foundation
import UIKit

class SelectPuzzleImageViewController : UIViewController, SelectPuzzleImageViewDelegate
{
    private var puzzleImageView:SelectPuzzleImageView?
    
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
        //self.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        puzzleImageView = SelectPuzzleImageView()
        puzzleImageView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        puzzleImageView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(puzzleImageView!)
        
        // constraint puzzle image view to the superview
        
        self.view.addConstraint(NSLayoutConstraint(item: puzzleImageView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: puzzleImageView!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))

        self.view.addConstraint(NSLayoutConstraint(item: puzzleImageView!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))

        self.view.addConstraint(NSLayoutConstraint(item: puzzleImageView!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))

        
     //   let puzzleImage = self.view as SelectPuzzleImageView
     //   puzzleImage.delegate = self

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // SelectPuzzleImageViewDelegate
    
    func  didSelectImageCollectionButton() ->Void
    {
        // we now want to let the user select an image from their camera
    }
}