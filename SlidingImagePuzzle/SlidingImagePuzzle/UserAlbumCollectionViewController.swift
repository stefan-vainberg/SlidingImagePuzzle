//
//  UserAlbumCollectionViewController.swift
//  SlidingImagePuzzle
//
//  Created by Stefan Vainberg on 10/25/14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

import Foundation
import UIKit
import Photos
import AssetsLibrary

class UserAlbumCollectionViewController : UIViewController, UICollectionViewDelegate
{
    
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

    
    
    // PRIVATE
    private var albumView:UserAlbumCollectionView?
    private var albumViewDataSource:UserAlbumCollectionViewDataSource?
    
    override func loadView()
    {
        super.loadView()
        self.view = UIView()
        self.view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        //self.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        albumViewDataSource = UserAlbumCollectionViewDataSource()
        albumView = UserAlbumCollectionView(delegate: self, dataSource: albumViewDataSource!)
        albumView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        albumView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(albumView!)
        
        self.view.addConstraint(NSLayoutConstraint(item: albumView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: albumView!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: albumView!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: albumView!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check if user lets us use their images
        let photoStatus =  ALAssetsLibrary.authorizationStatus()
        if (photoStatus != ALAuthorizationStatus.Authorized) {
            return;
        }
        else {
            self.ConsumeUserImages()
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func ConsumeUserImages() -> Void
    {
        // load up the images on the user's device
        let cachingManager = PHCachingImageManager()
        
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        
        if let results = PHAsset.fetchAssetsWithMediaType(.Image, options: options) {
            var assets: [PHAsset] = []
            results.enumerateObjectsUsingBlock { (object, idx, _) in
                if let asset = object as? PHAsset {
                    PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .AspectFill, options: nil) { (result, _) in
                        self.albumViewDataSource!.imagesToDisplay!.append(result)
                        self.albumView!.reloadData()
                    }
                    assets.append(asset)
                }
            }
            cachingManager.startCachingImagesForAssets(assets, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFit, options: nil)
        }

    }

}