//
//  SearchDelegate.swift
//  Clique
//
//  Created by Phil Hawkins on 3/13/18.
//  Copyright © 2018 Phil Hawkins. All rights reserved.
//

import Foundation

class SearchDelegate: BrowseDelegate {
    
    //MARK: - properties
    
    var search: SearchMode { return manager.controller.searching }
    var query: String { return manager.controller.query }
    
    var users = [User]()
    var songs = [Song]()
    var artists = [Artist]()
    var albums = [Album]()
    
    //MARK: - actions
    
    override func populate() {
        super.populate()
        
        users.removeAll()
        songs.removeAll()
        artists.removeAll()
        albums.removeAll()
        
        switch search {
        case .users: users = CliqueAPI.search(user: query)
        case .applemusic:
            let results = AppleMusicAPI.search(query)
            
            for item in results {
                switch item {
                case let item as Song: songs.append(item)
                case let item as Artist where artists.count < 3: artists.append(item)
                default: break
                }
            }
        case .spotify:
            let results = SpotifyAPI.search(query)
            
            for item in results {
                switch item {
                case let item as Song: songs.append(item)
                case let item as Artist where artists.count < 3: artists.append(item)
                default: break
                }
            }
        case .none, .library: break
        }
    }
    
    override func title() {
        manager.controller.title = "Search"
        
        manager.controller.addButton.isEnabled = false
        manager.controller.editButton.isEnabled = false
    }
    
    //MARK: - table delegate stack
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching { return super.tableView(tableView, didSelectRowAt: indexPath) }
        
        switch search {
        case .users where final: manager.find(friend: users[indexPath.row].id); fallthrough
        case .users: manager.view(user: users[indexPath.row].id)
        case .applemusic where indexPath.section == 0,
             .spotify where indexPath.section == 0: manager.view(catalog: artists[indexPath.row])
        case .applemusic where adding,
             .spotify where adding: self.tableView(tableView, commit: .insert, forRowAt: indexPath)
        case .applemusic where final,
             .spotify where final: manager.find(songs: [songs[indexPath.row]]); fallthrough
        case .applemusic, .spotify:
            let playlist = Playlist(
                owner: "",
                id: "",
                library: search == .applemusic ? Catalogues.AppleMusic.rawValue : Catalogues.Spotify.rawValue,
                name: "Search",
                social: false,
                songs: songs
            )
            manager.play(playlist: playlist, at: indexPath.row)
        case .none, .library: break
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if searching { return super.tableView(tableView, editingStyleForRowAt: indexPath) }
        
        switch search {
        case .users: return .none
        case .applemusic where indexPath.section == 0,
             .spotify where indexPath.section == 0: return .none
        case .applemusic, .spotify: return adding ? .insert : .none
        case .none, .library: return .none
        }
    }
    
    //MARK: - table data source stack
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if searching { return super.numberOfSections(in: tableView) }
        
        switch search {
        case .users: return 1
        case .applemusic, .spotify: return 2
        case .none, .library: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching { return super.tableView(tableView, numberOfRowsInSection: section) }
        
        switch search {
        case .users: return users.count
        case .applemusic where section == 0,
             .spotify where section == 0: return artists.count
        case .applemusic, .spotify: return songs.count
        case .none, .library: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "QueueSongTableViewCell", bundle: nil), forCellReuseIdentifier: "song")
        if searching { return super.tableView(tableView, cellForRowAt: indexPath) }
        
        switch search {
        case .users:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = "@" + users[indexPath.row].username
            cell.accessoryType = .disclosureIndicator
            cell.imageView?.image = UIImage(named: "clique 120.png")
            cell.setImageSize(to: 50)
            cell.imageView?.layer.cornerRadius = cell.frame.size.width / 2
            cell.imageView?.clipsToBounds = true
            if let current = users[indexPath.row].queue.current {
                cell.detailTextLabel?.text = "🔊" + current.artist.name + " - " + current.title
            } //TODO: set detail text label listening
            return cell
        case .applemusic where indexPath.section == 0,
             .spotify where indexPath.section == 0:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = artists[indexPath.row].name
            cell.accessoryType = .disclosureIndicator
            return cell
        case .applemusic, .spotify:
            let cell = tableView.dequeueReusableCell(withIdentifier: "song") as! QueueSongTableViewCell
            cell.set(song: songs[indexPath.row])
            cell.voteslabel.text = nil
            return cell
        case .none, .library: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searching { return super.tableView(tableView, canEditRowAt: indexPath) }
        
        switch search {
        case .users: return false
        case .applemusic where indexPath.section == 0,
             .spotify where indexPath.section == 0:
            return false
        case .applemusic, .spotify: return true
        case .none, .library: return false
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if searching { super.tableView(tableView, commit: editingStyle, forRowAt: indexPath) }
        
        switch editingStyle {
        case .insert: Alerts.queue(song: songs[indexPath.row])
        case .delete, .none: break
        }
    }
    
}