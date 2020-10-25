//
//  Config.swift
//  movie
//
//  Created by Thong Hao Yi on 23/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import UIKit

struct Config {
    static let baseUrl = "https://api.themoviedb.org"
    static let apiVersion = "3"
    static let apiKey = "328c283cd27bd1877d9080ccb1604c91"
    static let imageBaseUrl = "https://image.tmdb.org/t/p/"
    static let posterSize = "w154"
    static let DetailSize = "w500"
}

struct API {
    static let getMovies = "discover/movie"
    static let getMovieDetail = "movie"
}


struct Cell {
    static let movieCell = "MovieTVCell"
}
