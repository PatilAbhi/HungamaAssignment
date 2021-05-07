//
//  MovieCastCrew.swift
//  HungamaAssignment
//
//  Created by Shree on 07/05/21.
//

import Foundation

struct MovieCastCrew: Codable
{
    var id: Int?
    var cast: [Cast]?
    var crew: [Crew]?
}

// MARK: - Cast
struct Cast: Codable {
    var adult: Bool?
    var gender, id: Int?
    var knownForDepartment, name, originalName: String?
    var popularity: Double?
    var profilePath: String?
    var castID: Int?
    var character, creditID: String?
    var order: Int?
    var department, job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
}

// MARK: - Crew
struct Crew: Codable {
    var adult: Bool?
    var gender, id: Int?
    var knownForDepartment, name, originalName: String?
    var popularity: Double?
    var profilePath: String?
    var character, creditID: String?
    var department, job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case character
        case creditID = "credit_id"
        case department, job
    }
}

/*
 crew
 adult": false,
             "gender": 2,
             "id": 2127,
             "known_for_department": "Directing",
             "name": "James Wan",
             "original_name": "James Wan",
             "popularity": 9.155,
             "profile_path": "/hZeFnl5vg7lPusYstuFtuY9Lpx5.jpg",
             "credit_id": "5cda4c019251417580d22b9c",
             "department": "Production",
             "job": "Producer"
 
 cast
 "adult": false,
             "gender": 2,
             "id": 1610940,
             "known_for_department": "Acting",
             "name": "Lewis Tan",
             "original_name": "Lewis Tan",
             "popularity": 14.988,
             "profile_path": "/lkW8gh20BuwzHecXqYH1eRVuWpb.jpg",
             "cast_id": 23,
             "character": "Cole Young",
             "credit_id": "5d647aaebcf8c9001575e2c1",
             "order": 0
 */
