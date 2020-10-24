//
//  PagingList.swift
//  movie
//
//  Created by Thong Hao Yi on 23/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import UIKit

struct PagingList<T: Codable>: Codable {
    let page, totalResults, totalPages: Int
    let results: [T]

    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

extension PagingList {
    
    var nextPage: Int? {
        if (totalPages > page) {
            return page + 1
        } else {
            return nil
        }
    }
}
