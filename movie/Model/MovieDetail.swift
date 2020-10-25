//
//  MovieDetail.swift
//  movie
//
//  Created by Thong Hao Yi on 24/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import Foundation

// MARK: - MovieDetail
struct MovieDetail: Codable {
    let title: String
    let genres: [Genre]
    let id: Int
    let overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let runtime: Int
    let spokenLanguages: [SpokenLanguage]
 
    enum CodingKeys: String, CodingKey {
        case title
        case genres
        case id
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case runtime
        case spokenLanguages = "spoken_languages"
    }
}

extension MovieDetail {
    
    func getAllGenres() -> String {
        guard genres.count > 0 else {
            return ""
        }
        
        var tempArray: [String] = []
        for genre in genres {
            tempArray.append("\u{2022} \(genre.name)")
        }
        
        return tempArray.joined(separator:"\n")
    }
    
    func getAllSpokenLanguage() -> String {
        guard spokenLanguages.count > 0 else {
            return ""
        }
        
        var tempArray: [String] = []
        for spokenLanguage in spokenLanguages {
            tempArray.append("\u{2022} \(spokenLanguage.name)")
        }
        
        return tempArray.joined(separator:"\n")
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}
