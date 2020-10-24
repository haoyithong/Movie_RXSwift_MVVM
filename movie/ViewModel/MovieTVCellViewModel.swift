//
//  MovieTVCellViewModel.swift
//  movie
//
//  Created by Thong Hao Yi on 23/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import UIKit

struct MovieTVCellViewModel {
    
    let title: String
    let popularity: Double
    let image: String
    
    init(movie: Movie) {
        self.title = movie.title
        self.popularity = movie.popularity
        self.image = movie.posterPath ?? movie.backdropPath ?? ""
    }
}
