//
//  Error.swift
//  movie
//
//  Created by Thong Hao Yi on 23/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import UIKit

enum APIError: Int, Error {
    case notFound = 404
    case unknow = 500
}
