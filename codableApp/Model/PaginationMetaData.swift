//
//  PaginationMetaData.swift
//  codableApp
//
//  Created by Or paz tal on 02/07/2019.
//  Copyright © 2019 Or paz tal. All rights reserved.
//

import UIKit

struct PaginationMetaData: Codable { 
    let total_count: Int // Total number of items available (not returned on every endpoint)
    let count: Int // Total number of items returned
    let offset: Int // Position in pagination
}
