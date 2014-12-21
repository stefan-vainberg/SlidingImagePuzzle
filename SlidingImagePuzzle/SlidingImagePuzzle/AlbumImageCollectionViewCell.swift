//
//  AlbumImageCollectionViewCell.swift
//  SlidingImagePuzzle
//
//  Created by Stefan Vainberg on 12/20/14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

import Foundation

class AlbumImageCollectionViewCell : AlbumCollectionViewCell
{
    func updateCell(cellImage:UIImage) -> Void
    {
        self.cellImageView!.image = cellImage
    }

}