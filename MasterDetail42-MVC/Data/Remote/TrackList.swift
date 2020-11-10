//
//  TrackList.swift
//  MasterDetail42-MVC
//
//  Created by gerardo carlos roderico pejo tan on 2020/11/05.
//

import Foundation

// MARK: - TrackList

struct TrackList: Decodable {
    
    var resultCount: Int
    var tracks: [Track]
    
    private enum CodingKeys: String, CodingKey {
        case resultCount
        case tracks = "results"
    }
    
    struct Track: Decodable {
        var trackName: String
        var artwork: String
        var price: Double?
        var genre: String
        var longDescription: String
        
        private enum CodingKeys: String, CodingKey {
            case trackName
            case artwork = "artworkUrl100"
            case price = "trackPrice"
            case genre = "primaryGenreName"
            case longDescription
        }
    }
    
}
