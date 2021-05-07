//
//  SearchedMovieArrayList.swift
//  HungamaAssignment
//
//  Created by Shree on 07/05/21.
//

import Foundation

class SearchedMovieArrayList: NSObject, NSCoding
{
    var movieID: Int?
    var movieTitle: String?
    
    init(movieID: Int, movieTitle: String)
    {
        self.movieID = movieID
        self.movieTitle = movieTitle
    }
    
    required convenience init(coder aDecoder: NSCoder)
    {
        let movieID = aDecoder.decodeObject(forKey: "movieID") as! Int
        let movieTitle = aDecoder.decodeObject(forKey: "movieTitle") as! String
        self.init(movieID: movieID, movieTitle: movieTitle)
    }

    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(movieID, forKey: "movieID")
        aCoder.encode(movieTitle, forKey: "movieTitle")
    }
}
