//
//  MultipleAlbumsCollectionViewController.swift
//  SlidingImagePuzzle
//
//  Created by Stefan Vainberg on 12/6/14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

import Foundation
import UIKit
import Photos
import AssetsLibrary

protocol MultipleAlbumsCollectionViewControllerDelegate
{
    func didSelectAlbumFromCollection(albumIdentifier:String) -> Void
}

class MultipleAlbumsCollectionViewController : UIViewController, UICollectionViewDelegate
{
    // INITIALIZERS
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
    
    // DELEGATE
    var delegate:MultipleAlbumsCollectionViewControllerDelegate?

    // PRIVATE
    private var albumView:UserAlbumCollectionView?
    private var albumViewDataSource:MultipleAlbumsCollectionViewDataSource?

    override func loadView()
    {
        super.loadView()
        self.view = UIView()
        self.view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        //self.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        albumViewDataSource = MultipleAlbumsCollectionViewDataSource()
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
        
        switch photoStatus {
        case ALAuthorizationStatus.Authorized:
            //self.ConsumeUserImages()
            self.ConsumeAlbumsWithType(PHAssetCollectionType.Album)
            self.ConsumeAlbumsWithType(PHAssetCollectionType.SmartAlbum)
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
                            if let photoAsset = object as? PHAsset {
                                if (photoAsset.mediaType == PHAssetMediaType.Image) {
                                    println("image")
                                    var shouldStop:ObjCBool = true
                                    stop.initialize(true)
                                    self.ConsumeAssetImage(photoAsset, albumName: asset.localizedTitle, albumIdentifier:asset.localIdentifier)
                                }
                            }
                        }
                    }
                }
            })
        }
    }
    
    func ConsumeAssetImage(imageAsset:PHAsset, albumName:String, albumIdentifier:String) -> Void
    {
        let requestOptions = PHImageRequestOptions()
        requestOptions.version = PHImageRequestOptionsVersion.Current
        
        PHImageManager.defaultManager().requestImageDataForAsset(imageAsset, options: requestOptions) { (result, metadata, orientation, _) -> Void in
            let imageFromData = UIImage(data: result)
            let properlyRotateImage = UIImage(CGImage: imageFromData!.CGImage, scale: 1.0, orientation: orientation)
            let scaledImage = self.scaleImageToFitCollectionCell(properlyRotateImage!)
            self.albumViewDataSource!.imagesToDisplay!.append(image:scaledImage, albumTitle:albumName, albumIdentifier:albumIdentifier)
            //self.albumViewDataSource!.fullSizeImages!.append(properlyRotateImage!)
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
        self.delegate!.didSelectAlbumFromCollection(self.albumViewDataSource!.imagesToDisplay![indexPath.item].albumIdentifier)
    }



}