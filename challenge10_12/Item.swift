//
//  Item.swift
//  challenge10_12
//
//  Created by Madiapps on 22/07/2022.
//

import UIKit

class Item: NSObject {

    var image: String
    var title: String
    var subtitle: String
    
    init(image: String, title: String, subtitle: String) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
    }
    
  
}
