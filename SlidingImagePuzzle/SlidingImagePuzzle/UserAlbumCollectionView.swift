//
//  UserAlbumCollectionView.swift
//  SlidingImagePuzzle
//
//  Created by Stefan Vainberg on 10/26/14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

import Foundation
import UIKit



class UserAlbumCollectionView : UIView
{
    // PUBLIC
    var cellSize:CGSize?
    
    // PRIVATE
    private var collectionView:UICollectionView?
    
    // INITIALIZERS
    init(delegate del:UICollectionViewDelegate, dataSource dataSrc:UICollectionViewDataSource) {
        super.init(frame: CGRectZero)
        self.ConfigureView(delegate: del, dataSource: dataSrc)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func ConfigureView(delegate del:UICollectionViewDelegate, dataSource dataSrc:UICollectionViewDataSource) -> Void
    {
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(150, 150)
        layout.sectionInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
        self.cellSize = layout.itemSize
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView!.registerClass(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.reuseIdentifier())
        collectionView!.registerClass(AlbumImageCollectionViewCell.self, forCellWithReuseIdentifier: AlbumImageCollectionViewCell.reuseIdentifier())
        collectionView!.delegate = del
        collectionView!.dataSource = dataSrc
        collectionView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "userAlbumCell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.addSubview(collectionView!)
        
        // constrain the collectionView
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["collectionView":collectionView!]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[collectionView]|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["collectionView":collectionView!]))

    }
    
    func reloadData() -> Void
    {
        collectionView!.reloadData()
    }
    
    func reloadData(indexPath:NSIndexPath) -> Void
    {
        collectionView!.reloadItemsAtIndexPaths([indexPath])
    }
}