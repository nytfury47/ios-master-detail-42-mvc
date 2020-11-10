//
//  Network.swift
//  MasterDetail42-MVC
//
//  Created by gerardo carlos roderico pejo tan on 2020/11/05.
//

import Foundation
import Alamofire

// MARK: - TrackListService

class TrackListService {
    
    // MARK: - Network Error

    enum NetworkError: Error {
        case dateParseError
        case invalidPath
        case parseError
        case requestError
    }
    
    // MARK: - Class methods

    static func fetchTrackList<T: Decodable>(type: T.Type,
                                             completionHandler: @escaping (T?, NetworkError?) -> Void) {
        let targetURL = "https://itunes.apple.com/search?term=star&country=au&media=movie"
        
        AF.request(targetURL)
            .validate()
            .responseDecodable(of: T.self) { (response) in
                switch response.result {
                    case .success:
                        print("Validation Successful")
                        completionHandler(response.value, nil)
                    case let .failure(error):
                        print(error)
                        completionHandler(nil, .requestError)
                }
            }
    }

}
