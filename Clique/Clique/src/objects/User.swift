//
//  User.swift
//  Clique
//
//  Created by Phil Hawkins on 1/2/18.
//  Copyright © 2018 Phil Hawkins. All rights reserved.
//

import Foundation

//MARK: - user class

struct User: Codable, Equatable {
    
    var username: String
    let id: String
    var queue: Queue
    var library: [Playlist]
    var applemusic: Bool
    var spotify: Bool
    
    init(_ username: String, id: String, queue: Queue, library: [Playlist], applemusic: Bool, spotify: Bool) {
        self.username = username
        self.id = id
        self.queue = queue
        self.library = library
        self.applemusic = applemusic
        self.spotify = spotify
    }
    
    init(user: User) {
        username = user.username
        id = user.id
        queue = user.queue
        library = user.library
        applemusic = user.applemusic
        spotify = user.spotify
    }
    
    static func ==(lhs: User, rhs: User) -> Bool {
        if lhs.id == rhs.id { return true }
        
        return false
    }
    
    func me() -> Bool {
        return self.id == Identity.me
    }
    
    func clone() -> User {
        return User(user: self)
    }

}
