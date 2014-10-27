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


class UserAlbumCollectionViewDataSource : NSObject, UICollectionViewDataSource
{
    var imagesToDisplay:[UIImage]?
    
    override init() {
        super.init()
        self.Initialize()
    }
    
    func Initialize() -> Void
    {
        self.imagesToDisplay = []
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("userAlbumCell", forIndexPath: indexPath) as UICollectionViewCell
        let imageView = UIImageView(image: self.imagesToDisplay![indexPath.row])
        
        cell.contentView.addSubview(imageView)
        
        return cell as UICollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesToDisplay!.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}