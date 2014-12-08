//
//  MultipleAlbumsCollectionViewDataSource.swift
//  SlidingImagePuzzle
//
//  Created by Stefan Vainberg on 12/6/14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

import Foundation
import UIKit

class MultipleAlbumsCollectionViewDataSource : NSObject, UICollectionViewDataSource
{
    var imagesToDisplay:[(image:UIImage, albumTitle:String, albumIdentifier:String)]?
    var fullSizeImages:[UIImage]?
    
    override init() {
        super.init()
        self.Initialize()
    }
    
    func Initialize() -> Void
    {
        self.imagesToDisplay = []
        self.fullSizeImages = []
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AlbumCollectionViewCell.reuseIdentifier(), forIndexPath: indexPath) as AlbumCollectionViewCell
        
        cell.updateCell(self.imagesToDisplay![indexPath.row].image, cellTitle: self.imagesToDisplay![indexPath.row].albumTitle)
        return cell as UICollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesToDisplay!.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
 
}