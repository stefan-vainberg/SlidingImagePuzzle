//
//  UserAlbumCollectionViewDataSource.swift
//  SlidingImagePuzzle
//
//  Created by Stefan Vainberg on 10/26/14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Photos
import AssetsLibrary


class UserAlbumCollectionViewDataSource : NSObject, UICollectionViewDataSource
{
    let maxNumCachedImages = 10
    var imagesToDisplay:[UIImage]?
    var imagesToDisplayIdentifiers:[NSString]?
    var fullSizeImages:[UIImage]?
    var reloadMethod:(() -> Void)?
    
    var imagesAssociativeDictionary:[NSString:UIImage]?
    var imagesLRUArray:[String]?
    var albumID:String?
    
    init(albumIdentifier:String) {
        super.init()
        self.Initialize(albumIdentifier)
    }
    
    func Initialize(albumIdentifier:String) -> Void
    {
        self.imagesToDisplay = []
        self.fullSizeImages = []
        self.imagesAssociativeDictionary = [:]
        self.imagesLRUArray = []
        self.albumID = albumIdentifier
        self.imagesToDisplayIdentifiers = []
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("userAlbumCell", forIndexPath: indexPath) as UICollectionViewCell
        
        let imageID = self.imagesToDisplayIdentifiers![indexPath.row]
        
        if let image = self.imagesAssociativeDictionary![imageID] {
            if (cell.contentView.subviews.count  > 0) {
                for subview in cell.contentView.subviews  {
                    subview.removeFromSuperview()
                }
            }
            let imageView = UIImageView(image: image)
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 3.0
            imageView.layer.borderColor = UIColor.blackColor().CGColor
            imageView.layer.borderWidth = 0.5
            cell.contentView.addSubview(imageView)
        }
        else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), { () -> Void in
                objc_sync_enter(self)
                self.FetchImageForIndexPath(indexPath, assetID: imageID)
                objc_sync_exit(self)
            })
        }
        return cell as UICollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesToDisplayIdentifiers!.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // HELPERS
    
    func FetchImageForIndexPath(indexPath:NSIndexPath, assetID:String) -> Void
    {
        if let images = PHAsset.fetchAssetsWithLocalIdentifiers([assetID], options: nil) {
            if (images.count > 0) {
                let imageAsset: PHAsset = images.objectAtIndex(0) as PHAsset
                self.ConsumeAssetImage(imageAsset)
            }
        }
    }
    
    func ConsumeAssetImage(imageAsset:PHAsset) -> Void
    {
        let requestOptions = PHImageRequestOptions()
        requestOptions.version = PHImageRequestOptionsVersion.Current
        
        PHImageManager.defaultManager().requestImageDataForAsset(imageAsset, options: requestOptions) { (result, metadata, orientation, _) -> Void in
            autoreleasepool{
                if (result.length > 10000000) {
                    // strange bug gives me 500 megs of image data sometimes. Could be that an asset is improperly marked as an image when it is in fact a video
                    return
                }
                let imageFromData = UIImage(data: result)
                
                if (imageFromData == nil) {
                    return
                }
                if (self.imagesLRUArray!.count > self.maxNumCachedImages) {
                    if let assetToPurgeId = self.imagesLRUArray!.last {
                        self.imagesLRUArray!.removeLast()
                        self.imagesAssociativeDictionary!.removeValueForKey(assetToPurgeId)
                    }
                    
                }
                let properlyRotateImage = UIImage(CGImage: imageFromData!.CGImage, scale: 1.0, orientation: orientation)
                let scaledImage = self.scaleImageToFitCollectionCell(properlyRotateImage!)
                self.imagesAssociativeDictionary![imageAsset.localIdentifier] = scaledImage
                self.imagesLRUArray!.insert(imageAsset.localIdentifier, atIndex: 0)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.reloadMethod!()
                })
            }
        }
    }
    
    func scaleImageToFitCollectionCell(image: UIImage) -> UIImage
    {
        let collectionViewCellSize = CGSizeMake(50, 50)
        
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

}