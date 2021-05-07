//
//  BaseURL.swift
//  HungamaAssignment
//
//  Created by Shree on 07/05/21.
//

import Foundation

struct BaseURL
{
    private struct Domains
    {
        static let FullDomain = "https://api.themoviedb.org/3/movie/"
        static let MainDomain = "https://api.themoviedb.org/3/movie/now_playing?"
        static let ImageDomain = "http://image.tmdb.org/t/p/w780"
    }
    
    private static let FullURL = Domains.FullDomain
    private static let MainURL = Domains.MainDomain
    private static let ImageURL = Domains.ImageDomain
    
    // MARK: - Main URL
    static var MovieCallingMainURL: String
    {
        return MainURL
    }
    
    // MARK: - Image URL
    static var MovieImageURL: String
    {
        return ImageURL
    }
    
    // MARK: - Movie Synopsis
    static var MovieSynopsis: String
    {
        return FullURL
    }
    
    // MARK: - Cast and Credits
    static var MovieCastCredits: String
    {
        return FullURL
    }
    
    // MARK: - Similar Movies
    static var MovieSimilarMovies: String
    {
        return FullURL
    }
    
    // MARK: - Vidoe URL String
    static var MoviesVideo: String
    {
        return FullURL
    }
}
