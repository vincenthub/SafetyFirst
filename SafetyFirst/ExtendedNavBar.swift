//
//  ExtendedNavBar.swift
//  SafetyFirst
//
//  Created by Vincent Pacul on 22/7/15.
//  Copyright (c) 2015 Vincent Pacul. All rights reserved.
//

import UIKit

class ExtendedNavBar: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func willMoveToWindow(newWindow: UIWindow?) {
        // Use the layer shadow to draw a one pixel hairline under this view.
        self.layer.shadowOffset = CGSizeMake(0,(1.0 / UIScreen.mainScreen().scale))
        self.layer.shadowRadius = 0
        // UINavigationBar's hairline is adaptive, its properties change with
        // the contents it overlies.  You may need to experiment with these
        // values to best match your content.
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.25
        
    }
}
