//
//  WorkspaceViewController.swift
//  SlidingImagePuzzle
//
//  Created by Stefan Vainberg on 10/20/14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

import Foundation
import UIKit

class WorkspaceViewController : UIViewController, SelectPuzzleImageViewControllerDelegate, UserAlbumCollectionViewControllerDelegate, PuzzleBoardViewControllerDelegate
{

    // PRIVATE VARIABLES
    
    private var selectImageController:SelectPuzzleImageViewController?
    private var imagesCollectionController:UserAlbumCollectionViewController?
    private var puzzleBoardViewController:PuzzleBoardViewController?
    private var workspace:WorkspaceView?

    //INITIALIZING
    
    func initialize() -> Void
    {
        selectImageController = SelectPuzzleImageViewController()
        selectImageController!.delegate = self
        
        imagesCollectionController = UserAlbumCollectionViewController()
        
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
        self.selectImageController!.view.frame = workspace!.bounds
    }
    
    
    // SelectPuzzleImageViewControllerDelegate
    
    func didSelectPuzzleImageViewButton() -> Void
    {
        
        // remove the selectImageController, and replace it with the select Images Controller
        self.selectImageController!.willMoveToParentViewController(nil)
        self.selectImageController!.view.removeFromSuperview()
        self.selectImageController!.removeFromParentViewController()

        
        self.addChildViewController(self.imagesCollectionController!)
        workspace!.addSubview(self.imagesCollectionController!.view)
        self.imagesCollectionController!.didMoveToParentViewController(self)
        self.imagesCollectionController!.view.frame = workspace!.bounds
        self.imagesCollectionController!.delegate = self
    }
    
    // UserAlbumCollectionViewControllerDelegate
    func didSelectImageFromCollection(image: UIImage) {
        self.imagesCollectionController!.willMoveToParentViewController(nil)
        self.imagesCollectionController!.view.removeFromSuperview()
        self.imagesCollectionController!.removeFromParentViewController()
        
        self.puzzleBoardViewController = PuzzleBoardViewController(image: self.scaleImageToFitWorkspace(image))
        self.puzzleBoardViewController!.delegate = self
        self.addChildViewController(self.puzzleBoardViewController!)
        workspace!.addSubview(self.puzzleBoardViewController!.view)
        self.puzzleBoardViewController!.didMoveToParentViewController(self)
        self.puzzleBoardViewController!.view.frame = workspace!.bounds
    }
    
    func scaleImageToFitWorkspace(image:UIImage) -> UIImage
    {
        
        let workspaceSize = workspace!.bounds
        
        // we need to figure out the appropriate amount to scale down
        let scaleDownWidthFactor = ceil(image.size.width / workspaceSize.width)
        let scaleDownHeightFactor = ceil(image.size.height / workspaceSize.height)
        
        let finalScaleDownFactor = max(scaleDownWidthFactor, scaleDownHeightFactor)
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width / finalScaleDownFactor, image.size.height / finalScaleDownFactor), false, 0.0)
        image.drawInRect(CGRectMake(0, 0, image.size.width / finalScaleDownFactor, image.size.height / finalScaleDownFactor))
        
        let returnImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return returnImage

    }
    
    // PuzzleBoardViewControllerDelegate
    
    func didFinishGeneratingPuzzle() {
        self.workspace!.layer.borderColor = UIColor.clearColor().CGColor
    }
}