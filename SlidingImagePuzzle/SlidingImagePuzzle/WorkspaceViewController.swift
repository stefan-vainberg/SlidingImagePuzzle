//
//  WorkspaceViewController.swift
//  SlidingImagePuzzle
//
//  Created by Stefan Vainberg on 10/20/14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

import Foundation
import UIKit

class WorkspaceViewController : UIViewController
{

    // PRIVATE VARIABLES
    
    private var selectImageController:SelectPuzzleImageViewController?
    private var workspace:WorkspaceView?

    //INITIALIZING
    
    func initialize() -> Void
    {
        selectImageController = SelectPuzzleImageViewController()
        workspace = WorkspaceView()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.initialize()
    }

    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initialize()
    }
    
    convenience override init()
    {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = UIView()
        self.view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight;
        self.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        workspace!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(workspace!)
        
        self.view.addConstraint(NSLayoutConstraint(item: workspace!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.LeftMargin, multiplier: 1.0, constant: 40))
        
        self.view.addConstraint(NSLayoutConstraint(item: workspace!, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.RightMargin, multiplier: 1.0, constant: -40))
        
        self.view.addConstraint(NSLayoutConstraint(item: workspace!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 40))
        
        self.view.addConstraint(NSLayoutConstraint(item: workspace!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -40))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInitialImageSelectionStateView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // SETUP VIEWS BASED ON GAME STATE
    func setupInitialImageSelectionStateView() -> Void
    {
        self.addChildViewController(selectImageController!)
        workspace!.addSubview(selectImageController!.view)
        self.selectImageController!.didMoveToParentViewController(self)
    }
    
}