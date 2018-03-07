//
//  LibraryDelegate.swift
//  Clique
//
//  Created by Phil Hawkins on 1/12/18.
//  Copyright © 2018 Phil Hawkins. All rights reserved.
//

import Foundation
import UIKit

class LibraryDelegate: BrowseDelegate {
    
    //MARK: - properties
    
    var library = [Playlist]()
    
    //MARK: - actions
    
    override func populate() {
        super.populate()
        
        let client = manager.client()
        library = client.library
    }
    
    override func title() {
        manager.controller.title = "Library"
    }
    
    //MARK: - table delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching { return super.tableView(tableView, didSelectRowAt: indexPath) }
        
        switch indexPath.section {
        case 0: manager.viewAllSongs()
        case 1: manager.view(playlist: library[indexPath.row])
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if searching { return super.tableView(tableView, viewForHeaderInSection: section) }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if searching
            { return super.tableView(tableView, targetIndexPathForMoveFromRowAt: sourceIndexPath, toProposedIndexPath: proposedDestinationIndexPath) }
        
        switch proposedDestinationIndexPath.section {
        case 0: return IndexPath(row: 0, section: 1)
        default: return proposedDestinationIndexPath
        }
    }
    
    //MARK: - table data source methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if searching { return super.numberOfSections(in: tableView) }
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching { return super.tableView(tableView, numberOfRowsInSection: section) }
        
        return section == 0 ? 1 : library.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searching { return super.tableView(tableView, cellForRowAt: indexPath) }
        
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "All Songs"
            cell.accessoryType = .disclosureIndicator
            return cell
        case 1:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = library[indexPath.row].name
            let count = library[indexPath.row].songs.count
            cell.detailTextLabel?.text = count == 1 ? count.description + " song" : count.description + " songs"
            cell.accessoryType = .disclosureIndicator
            return cell
        default: return UITableViewCell()
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
        
        return indexPath.section != 0 //== 0 ? false : manager.client().me()
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if searching { return super.tableView(tableView, canMoveRowAt: indexPath) }
        
        return indexPath.section != 0 //== 0 ? false : manager.client().me()
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if searching { return }
        
        let mover = library[sourceIndexPath.row]
        library.remove(at: sourceIndexPath.row)
        library.insert(mover, at: destinationIndexPath.row)
        manager.update(with: library)
    }

}
