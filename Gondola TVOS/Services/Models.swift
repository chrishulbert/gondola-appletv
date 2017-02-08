//
//  Models.swift
//  Gondola TVOS
//
//  Created by Chris Hulbert on 8/2/17.
//  Copyright © 2017 Chris Hulbert. All rights reserved.
//

import Foundation

struct GondolaMetadata {
    let tvShows:  [TVShowMetadata]
    let movies:   [MovieMetadata]
    let capacity: String
}

struct MovieMetadata {
    // TODO
}

struct TVShowMetadata {
    let tmdbId:       Int
    let name:         String
    let overview:     String
    let image:        String
    let backdrop:     String
    let firstAirDate: String
    let lastAirDate:  String
    let seasons:      [TVSeasonMetadata]
}

struct TVSeasonMetadata {
    let tmdbId:   Int
    let season:   Int
    let name:     String
    let overview: String
    let image:    String
    let airDate:  String
    let episodes: [TVEpisodeMetadata]
}

struct TVEpisodeMetadata {
    let tmdbId:         Int
    let episode:        Int
    let name:           String
    let overview:       String
    let image:          String
    let media:          String
    let airDate:        String
    let productionCode: String
    let vote:           Float
}

extension GondolaMetadata {
    static func parse(from: [AnyHashable: Any]) -> GondolaMetadata {
        let t = from["TVShows"]  as? [[AnyHashable: Any]]
        let m = from["Movies"]   as? [[AnyHashable: Any]]
        let c = from["Capacity"] as? String
    }
}

TVShowMetadata

extension TVSeasonMetadata {
    static func parse(from: [AnyHashable: Any]) -> TVSeasonMetadata {
        let e = from["Episodes"] as? [[AnyHashable: Any]] ?? []
        return TVSeasonMetadata(tmdbId: from["TMDBId"] as? Int ?? 0,
                                season: from["Season"] as? Int ?? 0,
                                name: from["Name"] as? String ?? "",
                                overview: from["Overview"] as? String ?? "",
                                image: from["Image"] as? String ?? "",
                                airDate: from["AirDate"] as? String ?? "",
                                episodes: eRaw.map(TVEpisodeMetadata.parse))
    }
}

extension TVEpisodeMetadata {
    static func parse(from: [AnyHashable: Any]) -> TVEpisodeMetadata {
        return TVEpisodeMetadata(tmdbId:         from["TMDBId"] as? Int ?? 0,
                                 episode:        from["Episode"] as? Int ?? 0,
                                 name:           from["Name"] as? String ?? "",
                                 overview:       from["Overview"] as? String ?? "",
                                 image:          from["Image"] as? String ?? "",
                                 media:          from["Media"] as? String ?? "",
                                 airDate:        from["AirDate"] as? String ?? "",
                                 productionCode: from["ProductionCode"] as? String ?? "",
                                 vote:           from["Vote"] as? Float ?? 0)
    }
}
