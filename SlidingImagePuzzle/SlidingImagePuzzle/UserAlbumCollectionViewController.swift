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

protocol UserAlbumCollectionViewControllerDelegate
{
    func didSelectImageFromCollection(image:UIImage) -> Void
}

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
    
    convenience init(albumIdentifier:String)
    {
        self.init()
        self.albumIdentifier = albumIdentifier
    }

    var delegate:UserAlbumCollectionViewControllerDelegate?
    
    // PRIVATE
    private var albumView:UserAlbumCollectionView?
    private var albumViewDataSource:UserAlbumCollectionViewDataSource?
    private var albumIdentifier:String?
    
    override func loadView()
    {
        super.loadView()
        self.view = UIView()
        self.view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        //self.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        albumViewDataSource = UserAlbumCollectionViewDataSource(albumIdentifier: self.albumIdentifier!)
        albumView = UserAlbumCollectionView(delegate: self, dataSource: albumViewDataSource!)
        func reloadMethod(indexPath:NSIndexPath) -> Void {
            albumView!.reloadData(indexPath)
        }
        albumViewDataSource!.reloadMethod = reloadMethod
        
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
        
        switch photoStatus {
            case ALAuthorizationStatus.Authorized:
                self.ConsumeAlbumWithIdentifier(self.albumIdentifier!)
            case ALAuthorizationStatus.NotDetermined, ALAuthorizationStatus.Restricted, ALAuthorizationStatus.Denied:
                
                // request access
                PHPhotoLibrary.requestAuthorization({ (status:PHAuthorizationStatus) -> Void in
                });
            default:
                println("nothing")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //CONSUME IMAGES
    
    func ConsumeAlbumWithIdentifier(albumIdentifier:String)
    {
        
        let options = PHFetchOptions()
        
        if let result = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([albumIdentifier], options: options) {
            var assets: [PHAsset] = []
            
            let photoCollection:PHAssetCollection = result.objectAtIndex(0) as PHAssetCollection
            
            if let photos = PHAsset.fetchAssetsInAssetCollection(photoCollection, options: options) {
                photos.enumerateObjectsUsingBlock({ (object, idx, stop) -> Void in
                    if let asset = object as? PHAsset {
                        //self.ConsumeAssetImage(asset)
                        self.albumViewDataSource!.imagesToDisplayIdentifiers!.append(asset.localIdentifier)
                        self.albumView!.reloadData()
                    }
                })
            }
            
        }
    }
    
    func ConsumeAlbumsWithType(type:PHAssetCollectionType) -> Void
    {
        let cachingManager = PHCachingImageManager()
        let options = PHFetchOptions()
        
        if let results = PHAssetCollection.fetchAssetCollectionsWithType(type, subtype: PHAssetCollectionSubtype.Any, options: options) {
            var assets: [PHAsset] = []
            
            results.enumerateObjectsUsingBlock({ (object, idx, _) -> Void in
                if let asset = object as? PHAssetCollection {
                                        
                    if let photoAssets = PHAsset.fetchAssetsInAssetCollection(asset, options: options) {
                        photoAssets.enumerateObjectsUsingBlock { (object, idx, stop) in
                            if let asset = object as? PHAsset {
                                self.ConsumeAssetImage(asset)
                                var shouldStop:ObjCBool = true
                                stop.initialize(true)
                            }
                        }
                    }
                }
            })
        }
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
                    self.ConsumeAssetImage(asset)
                    assets.append(asset)
                }
            }
            cachingManager.startCachingImagesForAssets(assets, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFit, options: nil)
        }
    }
    
    func ConsumeAssetImage(imageAsset:PHAsset) -> Void
    {
        let requestOptions = PHImageRequestOptions()
        requestOptions.version = PHImageRequestOptionsVersion.Current
        
        PHImageManager.defaultManager().requestImageDataForAsset(imageAsset, options: requestOptions) { (result, metadata, orientation, _) -> Void in
            let imageFromData = UIImage(data: result)
            if (imageFromData == nil) {
                return
            }
            let properlyRotateImage = UIImage(CGImage: imageFromData!.CGImage, scale: 1.0, orientation: orientation)
            let scaledImage = self.scaleImageToFitCollectionCell(properlyRotateImage!)
            self.albumViewDataSource!.imagesToDisplay!.append(scaledImage)
            self.albumViewDataSource!.fullSizeImages!.append(properlyRotateImage!)
            self.albumView!.reloadData()
        }
    }
    
    func scaleImageToFitCollectionCell(image: UIImage) -> UIImage
    {
        let collectionViewCellSize = self.albumView!.cellSize!
        
        // we need to figure out the appropriate amount to scale down
        let scaleDownWidthFactor = ceil(image.size.width / collectionViewCellSize.width)
        let scaleDownHeightFactor = ceil(image.size.height / collectionViewCellSize.height)
        
        let finalScaleDownFactor = max(scaleDownWidthFactor, scaleDownHeightFactor)
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width / finalScaleDownFactor, image.size.height / finalScaleDownFactor), false, 0.0)
        image.drawInRect(CGRectMake(0, 0, image.size.width / finalScaleDownFactor, image.size.height / finalScaleDownFactor))
        
        let returnImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return returnImage
    }
    
    
    // UICOllectionViewDelegate methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedImage = self.albumViewDataSource!.imagesAssociativeDictionary![self.albumViewDataSource!.imagesToDisplayIdentifiers![indexPath.item]]
        println("\(selectedImage!.size)")
        self.delegate!.didSelectImageFromCollection(selectedImage!)
    }
}