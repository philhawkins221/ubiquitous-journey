//
//  SettingsTableViewCell.swift
//  Clique
//
//  Created by Phil Hawkins on 3/28/18.
//  Copyright © 2018 Phil Hawkins. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    //MARK: - outlets
    
    @IBOutlet weak var slider: UISwitch!
    
    //MARK: - properties
    
    var delegate: SettingsDelegate?
    
    //MARK: - table view cell stack
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
