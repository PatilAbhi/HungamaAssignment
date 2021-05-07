//
//  MovieSimilarMovies.swift
//  HungamaAssignment
//
//  Created by Shree on 07/05/21.
//

import Foundation

struct MovieSimilarMovies: Codable
{
    var page: Int?
    var results: [SimilarMovieList]?
    var totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - SimilarMovieList
struct SimilarMovieList: Codable {
    var adult: Bool?
    var backdropPath: String?
    var genreIDS: [Int]?
    var id: Int?
//    var originalLanguage: OriginalLanguage?
    var originalTitle, overview, posterPath, releaseDate: String?
    var title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    var popularity: Double?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
//        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
    }
}

enum OriginalLanguage: String, Codable {
    case cn = "cn"
    case en = "en"
}
