//
//  ResultsMetaData.swift
//  codableApp
//
//  Created by Or paz tal on 02/07/2019.
//  Copyright © 2019 Or paz tal. All rights reserved.
//

import UIKit

struct SearchResultsMetaData: Codable {
    let data: [ItemMetaData]
    let pagination: PaginationMetaData?
    let meta: MetaData?
}
