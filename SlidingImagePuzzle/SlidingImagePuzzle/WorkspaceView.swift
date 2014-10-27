//
//  WorkspaceView.swift
//  SlidingImagePuzzle
//
//  Created by Stefan Vainberg on 10/20/14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

import Foundation
import UIKit

class WorkspaceView : UIView
{
    // INITIALIZERS
    override convenience init() {
        self.init(frame:CGRectZero)
        self.configureWorkspaceView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureWorkspaceView()
    }
    
    // SETUP
    func configureWorkspaceView() -> Void
    {
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1.5
        self.layer.cornerRadius = 3.0

    }
    
}
