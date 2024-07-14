//
//  ImageListModel.swift
//  CamPlace
//
//  Created by Chung Wussup on 6/15/24.
//

import Foundation


struct ImageListModel: BasedItem {
    var imageUrl: String?
    var title: String?
    var subTitle: String?
    var mapX: String?
    var mapY: String?
    
    let contentId: String
    let serialnum: String
    let createdtime: String
    let modifiedtime: String
}
