//
//  Items.swift
//  PipeLineAR
//
//  Created by Tuncay Cansız on 14.09.2019.
//  Copyright © 2019 Tuncay Cansız. All rights reserved.
//

import Foundation

struct Items {
    private(set) public var groupName: String
    private(set) public var itemName : String
    private(set) public var itemImage: String
    
    init(groupName: String, itemName: String, itemImage: String) {
        self.groupName = groupName
        self.itemName = itemName
        self.itemImage = itemImage
    }
}
