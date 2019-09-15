//
//  DeviceControl.swift
//  PipeLineAR
//
//  Created by Tuncay Cansız on 13.09.2019.
//  Copyright © 2019 Tuncay Cansız. All rights reserved.
//

import UIKit

// Device (type) control model
//Cihaz (türünü) kontrolünü sağlayan model
struct Device{
    
    static var deviceModel : String {
        let model = UIDevice.current.model
        return model
    }
    
    static var screenWidth : CGFloat{
        let screenWidth = UIScreen.main.bounds.size.width
        return screenWidth
    }
    
    static var screenHeight : CGFloat{
        let screenHeight = UIScreen.main.bounds.size.height
        return screenHeight
    }
    
}
