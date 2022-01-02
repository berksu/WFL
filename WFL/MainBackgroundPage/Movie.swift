//
//  Movie.swift
//  WFL
//
//  Created by Berksu Kısmet on 2.01.2022.
//

import Foundation

struct Movie: Codable, Hashable{
    let idForLoop = UUID()
    let id : Int
    let title: String?
    let release_date: String?
    let image: String?
    let voteAverage: Float?
    let voteCount: Float?
    let overview: String?
    let backdropPath: String?
    let genreIDs: [Int]?

    //"https://www.themoviedb.org/t/p/w1280"
    enum CodingKeys: String, CodingKey{
        case id, title, release_date , image = "poster_path", voteAverage = "vote_average", voteCount = "vote_count", overview, backdropPath = "backdrop_path", genreIDs = "genre_ids"
    }
}
