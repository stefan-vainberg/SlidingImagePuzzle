//
//  AlbumCollectionViewCell.swift
//  SlidingImagePuzzle
//
//  Created by Stefan Vainberg on 12/7/14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

import Foundation
import UIKit


class AlbumCollectionViewCell: UICollectionViewCell
{
    
    // PRIVATE
    private var cellImageView:UIImageView?
    private var cellTitle: String?
    
    class func reuseIdentifier() -> String
    {
        return "albumCollectionCell"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeCell()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //INITIALIZE
    func initializeCell() -> Void
    {
        self.layer.cornerRadius = 3.0
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 0.5
        cellImageView = UIImageView()
        cellImageView!.clipsToBounds = true
        cellImageView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        cellImageView!.frame = self.bounds
        self.contentView.addSubview(cellImageView!)
    }
    
    func updateCell(cellImage:UIImage, cellTitle:String) -> Void
    {
        self.cellTitle = cellTitle
        self.cellImageView!.image = cellImage
        self.cellImageView!.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
        
        // attach the blur effect 
        var blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        blurEffectView.frame = self.cellImageView!.bounds
        self.cellImageView!.addSubview(blurEffectView)
        
        var vibrancyEffect = UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: .Dark))
        var vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = self.cellImageView!.bounds
        blurEffectView.contentView.addSubview(vibrancyEffectView)
        
        let cellLabel = UILabel()
        cellLabel.textColor = UIColor.blackColor()
        cellLabel.text = cellTitle
        cellLabel.sizeToFit()
        cellLabel.center = CGPointMake(self.cellImageView!.bounds.size.width/2, self.cellImageView!.bounds.size.height/2)
        vibrancyEffectView.contentView.addSubview(cellLabel)
        
        
    }
}