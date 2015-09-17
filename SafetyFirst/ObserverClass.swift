//
//  ObserverClass.swift
//  SafetyFirst
//
//  Created by Vincent Pacul on 21/7/15.
//  Copyright (c) 2015 Vincent Pacul. All rights reserved.
//

import Foundation
import UIKit

class ObserverClass{

    
    private var thisViewController:UIViewController!
    
    //It makes this class to be a singleton
    class var sharedInstance: ObserverClass {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: ObserverClass? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ObserverClass()
        }
        return Static.instance!
    }

    
    func observApplicationState(viewController:UIViewController){
        
        thisViewController = viewController
        
        NSNotificationCenter.defaultCenter().addObserver(thisViewController, selector: Selector("backgroundObserverMethod:"), name:UIApplicationDidEnterBackgroundNotification, object: nil)

    }
    
        
    //Delay timer method
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
   
    //dissmiss this view
    func dismissView(){
        thisViewController.dismissViewControllerAnimated(true, completion: nil)
    }

}