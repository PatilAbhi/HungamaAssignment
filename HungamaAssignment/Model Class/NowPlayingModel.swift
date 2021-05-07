//
//  NowPlayingModel.swift
//  HungamaAssignment
//
//  Created by Shree on 07/05/21.
//

import Foundation

struct NowPlayingModel: Codable
{
    var dates: Dates?
    var page: Int?
    var results: [MovieResult]?
    var totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct MovieResult: Codable
{
    var adult: Bool?
    var backdropPath: String?
    var id: Int?
    var originalLanguage, originalTitle, overview: String?
    var popularity: Double?
    var posterPath, releaseDate, title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}


// MARK: - Dates
struct Dates: Codable
{
    var maximum, minimum: String?
}
