//
//  GifMetaData.swift
//  codableApp
//
//  Created by Or paz tal on 02/07/2019.
//  Copyright © 2019 Or paz tal. All rights reserved.
//

import UIKit

struct ItemMetaData: Codable { 
    let type: String
    let id: String
    let url: String
    let title : String?
    let images : ImagesMetaData?
}

struct ImagesMetaData: Codable {
    let fixed_height : FixedHeightMetaData?
}

struct FixedHeightMetaData: Codable {
    let url : String?
    let width : String?
    let height : String?
    let size : String?
}

