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
    
    func replayGame() -> Void
    {
        self.workspace!.layer.borderColor = UIColor.blackColor().CGColor
        self.didSelectPuzzleImageViewButton()
    }
    
    func setupInitialImageSelectionStateView() -> Void
    {
        self.AddVC(selectImageController!)
    }
    
    
    // SelectPuzzleImageViewControllerDelegate
    
    func didSelectPuzzleImageViewButton() -> Void
    {
        
        // remove the selectImageController, and replace it with the select Images Controller
        self.RemoveVC(self.selectImageController!)

        self.AddVC(self.imagesCollectionController!)
        self.imagesCollectionController!.delegate = self
    }
    
    // UserAlbumCollectionViewControllerDelegate
    func didSelectImageFromCollection(image: UIImage) {
        self.RemoveVC(self.imagesCollectionController!)
        
        self.puzzleBoardViewController = PuzzleBoardViewController(image: self.scaleImageToFitWorkspace(image))
        self.puzzleBoardViewController!.delegate = self
        self.AddVC(self.puzzleBoardViewController!)
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
    
    func didWinPuzzleGame() {
        // remove the selectImageController, and replace it with the select Images Controller
        self.RemoveVC(self.puzzleBoardViewController!)
        self.replayGame()
    }
    
    
    // UTILITY
    func RemoveVC(viewController:UIViewController) -> Void
    {
        viewController.willMoveToParentViewController(nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()

    }
    
    func AddVC(viewController:UIViewController) -> Void
    {
        self.addChildViewController(viewController)
        workspace!.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        viewController.view.frame = workspace!.bounds

    }
}